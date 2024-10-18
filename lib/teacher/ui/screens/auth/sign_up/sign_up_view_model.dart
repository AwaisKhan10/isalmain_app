import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/model/custom_auth_result.dart';
import 'package:sheduling_app/teacher/core/model/teacher_user.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';
import 'package:sheduling_app/locator.dart';

import 'package:sheduling_app/teacher/ui/screens/root/root_screen.dart';

class TeacherSignUpViewModel extends BaseViewModel {
  //with the help of locator we once declare the instance of authetication service
  //globally and the call it every where in the app
  final _authservice = locator<AuthServices>();
  final _database = locator<DatabaseServices>();

  //this is the class where simple we declare three variables, var,bool, string for
  //the sake of our ease
  CustomAuthResult customAuthResult = CustomAuthResult();

  //controllers for textfeilds
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //this is the instance of model class
  TeacherUser teacherUser = TeacherUser();
  bool isShowpassword = true;

  //for the obsecure toggle icon
  toggleShowPassword() {
    isShowpassword = !isShowpassword;
    notifyListeners();
  }

  void signUpwithEmailandPassword() async {
    setState(ViewState.busy);

    customAuthResult =
        await _authservice.signUpwithEmailandPassword(teacherUser);
    if (customAuthResult.status!) {
      _authservice.isLogin = true;
      Get.snackbar('Register', 'User Registered Succesfully');
      Get.to(() => const RootScreen());
      notifyListeners();
    } else {
      setState(ViewState.idle);
      Get.snackbar("Error", "${customAuthResult.errorMessage}");
      notifyListeners();
    }
    setState(ViewState.idle);
    notifyListeners();
  }
}
