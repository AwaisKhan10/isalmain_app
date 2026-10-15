import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:sheduling_app/teacher/core/model/custom_auth_result.dart';
import 'package:sheduling_app/teacher/core/model/student_user.dart';
import 'package:sheduling_app/teacher/core/model/teacher_user.dart';
import 'package:sheduling_app/teacher/core/services/auth_exception.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';

class AuthServices extends ChangeNotifier with WidgetsBindingObserver {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  final DatabaseServices databaseServices = DatabaseServices();
  CustomAuthResult customAuthResult = CustomAuthResult();
  AuthExceptionsService authExceptionsService = AuthExceptionsService();
  User? user;
  bool? isLogin;
  bool isTeacher = true;
  bool isInitialized = false; // Add this
  TeacherUser teacherUser = TeacherUser();
  StudentUser studentUser = StudentUser();

  String get currentUserId => 
    isTeacher ? (teacherUser.id ?? "") : (studentUser.id ?? "");

  AuthServices() {
    init();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (currentUserId.isNotEmpty) {
        databaseServices.updateUserStatus(currentUserId, isTeacher, true);
      }
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      if (currentUserId.isNotEmpty) {
        databaseServices.updateUserStatus(currentUserId, isTeacher, false);
      }
    }
  }

  ///
  ///Checking if the user is login or not
  ///
  init() async {
    user = _auth.currentUser;
    if (user != null) {
      isLogin = true;
      teacherUser = await databaseServices.getTeacherUser(user!.uid);
      studentUser = await databaseServices.getStudentUser(user!.uid);

      final hasTeacherProfile = teacherUser.id != null && teacherUser.email != null;
      final hasStudentProfile = studentUser.id != null && studentUser.email != null;

      if (hasTeacherProfile) {
        isTeacher = true;
      } else if (hasStudentProfile) {
        isTeacher = false;
      } else {
        isLogin = false;
        isTeacher = true;
      }
      // Update online status in init
      if (currentUserId.isNotEmpty) {
        databaseServices.updateUserStatus(currentUserId, isTeacher, true);
      }
    } else {
      isLogin = false;
    }
    isInitialized = true;
    notifyListeners();
  }

  Future<void> reloadCurrentUser() async {
    user = _auth.currentUser;
    if (user == null) return;

    if (isTeacher) {
      teacherUser = await databaseServices.getTeacherUser(user!.uid);
    } else {
      studentUser = await databaseServices.getStudentUser(user!.uid);
    }
    notifyListeners();
  }

  ///
  ///Signup Teacher with Email and Password
  ///
  signUpTeacher(TeacherUser teacherUser) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
          email: teacherUser.email!, password: teacherUser.password!);
      if (credentials.user == null) {
        customAuthResult.status = false;
        customAuthResult.errorMessage = "An undifined error happened";
        return customAuthResult;
      }
      if (credentials.user != null) {
        customAuthResult.status = true;
        customAuthResult.user = credentials.user;
        teacherUser.id = credentials.user!.uid;
        this.teacherUser = teacherUser;
        debugPrint('Assigned User ID: ${teacherUser.id}');
        debugPrint("$credentials");

        await databaseServices.addTeacherUser(teacherUser);
        notifyListeners();
      }
    } catch (e) {
      customAuthResult.status = false;
      customAuthResult.errorMessage =
          AuthExceptionsService.generateExceptionMessage(e);
    }
    return customAuthResult;
  }

  ///
  ///Signup Student with Email and Password
  ///
  signUpStudent(StudentUser studentUser) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
          email: studentUser.email!, password: studentUser.password!);
      if (credentials.user == null) {
        customAuthResult.status = false;
        customAuthResult.errorMessage = "An undefined error happened";
        return customAuthResult;
      }
      if (credentials.user != null) {
        customAuthResult.status = true;
        customAuthResult.user = credentials.user;
        studentUser.id = credentials.user!.uid;
        this.studentUser = studentUser;
        isTeacher = false;
        debugPrint('Assigned Student ID: ${studentUser.id}');

        await databaseServices.addStudentUser(studentUser);
        notifyListeners();
      }
    } catch (e) {
      customAuthResult.status = false;
      customAuthResult.errorMessage =
          AuthExceptionsService.generateExceptionMessage(e);
    }
    return customAuthResult;
  }

  ///
  ///Login with email and password
  ///
  loginWithEmailandPassword({email, password}) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credentials.user == null) {
        customAuthResult.status = false;
        customAuthResult.errorMessage = "Invalid Username and Password";
        return customAuthResult;
      }
      if (credentials.user != null) {
        // Try fetching as teacher
        teacherUser =
            await databaseServices.getTeacherUser(credentials.user!.uid);

        if (teacherUser.id != null) {
          isTeacher = true;
        } else {
          // Try fetching as student
          studentUser =
              await databaseServices.getStudentUser(credentials.user!.uid);
          if (studentUser.id != null) {
            isTeacher = false;
          }
        }

        customAuthResult.status = true;
        customAuthResult.user = credentials.user;
        isInitialized = true;

        // Update online status after login
        if (currentUserId.isNotEmpty) {
          await databaseServices.updateUserStatus(currentUserId, isTeacher, true);
        }
        
        notifyListeners();
      }
    } catch (e) {
      customAuthResult.status = false;
      customAuthResult.errorMessage =
          AuthExceptionsService.generateExceptionMessage(e);
    }
    return customAuthResult;
  }


  bool _hasTeacherProfile(TeacherUser teacher) =>
      teacher.id != null && teacher.email != null && teacher.email!.isNotEmpty;

  bool _hasStudentProfile(StudentUser student) =>
      student.id != null && student.email != null && student.email!.isNotEmpty;

  Future<CustomAuthResult> signInWithGoogle({required bool asTeacher}) async {
    customAuthResult = CustomAuthResult();
    try {
      await _googleSignIn.signOut();
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        customAuthResult.status = false;
        customAuthResult.errorMessage = 'Google sign in cancelled';
        return customAuthResult;
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        customAuthResult.status = false;
        customAuthResult.errorMessage =
            'Google sign in failed. Please try again.';
        return customAuthResult;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      user = userCredential.user;
      if (user == null) {
        customAuthResult.status = false;
        customAuthResult.errorMessage = 'Google sign in failed';
        return customAuthResult;
      }

      teacherUser = await databaseServices.getTeacherUser(user!.uid);
      studentUser = await databaseServices.getStudentUser(user!.uid);
      final hasTeacher = _hasTeacherProfile(teacherUser);
      final hasStudent = _hasStudentProfile(studentUser);

      if (asTeacher) {
        if (hasTeacher) {
          isTeacher = true;
          isLogin = true;
          isInitialized = true;
          if (currentUserId.isNotEmpty) {
            await databaseServices.updateUserStatus(currentUserId, true, true);
          }
          customAuthResult.status = true;
          customAuthResult.user = user;
          notifyListeners();
          return customAuthResult;
        }
        if (hasStudent) {
          await logout();
          customAuthResult.status = false;
          customAuthResult.errorMessage =
              'This Google account is registered as a student. Please sign in from the student screen.';
          return customAuthResult;
        }
        isTeacher = true;
        isLogin = false;
        teacherUser = TeacherUser(
          id: user!.uid,
          email: user!.email ?? googleUser.email,
          fullName: user!.displayName ?? googleUser.displayName,
          profileImageUrl: user!.photoURL ?? googleUser.photoUrl,
        );
        customAuthResult.status = true;
        customAuthResult.user = user;
        customAuthResult.needsProfileCompletion = true;
        notifyListeners();
        return customAuthResult;
      }

      if (hasStudent) {
        isTeacher = false;
        isLogin = true;
        isInitialized = true;
        if (currentUserId.isNotEmpty) {
          await databaseServices.updateUserStatus(currentUserId, false, true);
        }
        customAuthResult.status = true;
        customAuthResult.user = user;
        notifyListeners();
        return customAuthResult;
      }
      if (hasTeacher) {
        await logout();
        customAuthResult.status = false;
        customAuthResult.errorMessage =
            'This Google account is registered as a teacher. Please sign in from the teacher screen.';
        return customAuthResult;
      }
      isTeacher = false;
      isLogin = false;
      studentUser = StudentUser(
        id: user!.uid,
        email: user!.email ?? googleUser.email,
        fullName: user!.displayName ?? googleUser.displayName,
        profileImageUrl: user!.photoURL ?? googleUser.photoUrl,
      );
      customAuthResult.status = true;
      customAuthResult.user = user;
      customAuthResult.needsProfileCompletion = true;
      notifyListeners();
      return customAuthResult;
    } catch (e) {
      debugPrint('Google sign in error: $e');
      customAuthResult.status = false;
      if (e is FirebaseAuthException) {
        customAuthResult.errorMessage =
            AuthExceptionsService.generateExceptionMessage(e);
      } else {
        customAuthResult.errorMessage =
            'Google sign in failed. Please try again.';
      }
      return customAuthResult;
    }
  }

  Future<CustomAuthResult> completeGoogleTeacherProfile(
      TeacherUser profile) async {
    customAuthResult = CustomAuthResult();
    if (user == null) {
      customAuthResult.status = false;
      customAuthResult.errorMessage = 'Please sign in with Google first';
      return customAuthResult;
    }
    try {
      profile.id = user!.uid;
      profile.email = user!.email ?? profile.email;
      profile.profileImageUrl ??= user!.photoURL;
      await databaseServices.addTeacherUser(profile);
      teacherUser = profile;
      isTeacher = true;
      isLogin = true;
      isInitialized = true;
      customAuthResult.status = true;
      customAuthResult.user = user;
      notifyListeners();
    } catch (e) {
      customAuthResult.status = false;
      customAuthResult.errorMessage =
          'Could not save teacher profile. Please try again.';
    }
    return customAuthResult;
  }

  Future<CustomAuthResult> completeGoogleStudentProfile(
      StudentUser profile) async {
    customAuthResult = CustomAuthResult();
    if (user == null) {
      customAuthResult.status = false;
      customAuthResult.errorMessage = 'Please sign in with Google first';
      return customAuthResult;
    }
    try {
      profile.id = user!.uid;
      profile.email = user!.email ?? profile.email;
      profile.profileImageUrl ??= user!.photoURL;
      await databaseServices.addStudentUser(profile);
      studentUser = profile;
      isTeacher = false;
      isLogin = true;
      isInitialized = true;
      customAuthResult.status = true;
      customAuthResult.user = user;
      notifyListeners();
    } catch (e) {
      customAuthResult.status = false;
      customAuthResult.errorMessage =
          'Could not save student profile. Please try again.';
    }
    return customAuthResult;
  }

  logout({id}) async {
    if (currentUserId.isNotEmpty) {
      await databaseServices.updateUserStatus(currentUserId, isTeacher, false);
    }
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
    isLogin = false;
    user = null;
    teacherUser = TeacherUser();
    studentUser = StudentUser();
  }
}
