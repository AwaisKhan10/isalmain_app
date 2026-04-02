import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sheduling_app/teacher/core/model/custom_auth_result.dart';
import 'package:sheduling_app/teacher/core/model/student_user.dart';
import 'package:sheduling_app/teacher/core/model/teacher_user.dart';
import 'package:sheduling_app/teacher/core/services/auth_exception.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';

class AuthServices extends ChangeNotifier with WidgetsBindingObserver {
  final _auth = FirebaseAuth.instance;

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
      // Try fetching as teacher first
      teacherUser = await databaseServices.getTeacherUser(user!.uid);
      if (teacherUser.id != null) {
        isTeacher = true;
      } else {
        // Try fetching as student
        studentUser = await databaseServices.getStudentUser(user!.uid);
        if (studentUser.id != null) {
          isTeacher = false;
        }
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

  logout({id}) async {
    if (currentUserId.isNotEmpty) {
      await databaseServices.updateUserStatus(currentUserId, isTeacher, false);
    }
    await _auth.signOut();
    isLogin = false;
    user = null;
  }
}
