import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sheduling_app/teacher/core/model/custom_auth_result.dart';
import 'package:sheduling_app/teacher/core/model/teacher/teacher_user.dart';
import 'package:sheduling_app/teacher/core/services/auth_exception.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';

class AuthServices extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final DatabaseServices databaseServices = DatabaseServices();
  CustomAuthResult customAuthResult = CustomAuthResult();
  AuthExceptionsService authExceptionsService = AuthExceptionsService();
  User? user;
  bool? isLogin;
  TeacherUser teacherUser = TeacherUser();

  AuthServices() {
    init();
  }

  ///
  ///Checking if the user is login or not
  ///
  init() async {
    user = _auth.currentUser;
    if (user != null) {
      isLogin = true;
    } else {
      isLogin = false;
    }
  }

  ///
  ///Signup with Email and Password
  ///
  signUpwithEmailandPassword(TeacherUser teacherUser) async {
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
        customAuthResult.status = true;
        customAuthResult.user = customAuthResult.user;
        teacherUser.id = credentials.user!.uid;
      }
    } catch (e) {
      customAuthResult.status = false;
      customAuthResult.errorMessage =
          AuthExceptionsService.generateExceptionMessage(e);
    }
    return customAuthResult;
  }

  logout({id}) async {
    await _auth.signOut();
    this.isLogin = false;
    this.user = null;
  }
}
