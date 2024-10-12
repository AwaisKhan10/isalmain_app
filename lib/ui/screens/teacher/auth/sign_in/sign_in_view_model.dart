import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sheduling_app/core/enums/view_state.dart';
import 'package:sheduling_app/core/model/custom_auth_result.dart';
import 'package:sheduling_app/core/model/teacher/teacher_user.dart';
import 'package:sheduling_app/core/services/auth_services.dart';
import 'package:sheduling_app/core/view_model/view_model.dart';
import 'package:sheduling_app/locator.dart';

import 'package:sheduling_app/ui/screens/teacher/root/root_screen.dart';

class SignInViewModel extends BaseViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TeacherUser teacherUser = TeacherUser();
  final AuthServices _authServices = locator<AuthServices>();
  CustomAuthResult customAuthResult = CustomAuthResult();

  bool isShowPassword = true;
  toggleShowPassword() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  void signInwithEmailandPassword() async {
    setState(ViewState.busy);
    customAuthResult = await _authServices.loginWithEmailandPassword(
        email: teacherUser.email, password: teacherUser.password);
    if (customAuthResult.status!) {
      _authServices.isLogin = true;
      Get.snackbar("Login", "User Loged In Successfully");
      Get.offAll(() => const RootScreen());
    } else {
      setState(ViewState.idle);
      Get.snackbar("Error", "${customAuthResult.errorMessage}");
      setState(ViewState.idle);
      notifyListeners();
    }
  }
}
