import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheduling_app/common/app_snackbar.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/model/custom_auth_result.dart';
import 'package:sheduling_app/teacher/core/model/teacher_user.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/teacher/ui/screens/root/root_screen.dart';

class TeacherSignInViewModel extends BaseViewModel {
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
      email: teacherUser.email,
      password: teacherUser.password,
    );

    if (customAuthResult.status!) {
      _authServices.isLogin = true;
      AppSnackbar.success('Logged in successfully');
      Get.offAll(() => const RootScreen());
    } else {
      AppSnackbar.error(customAuthResult.errorMessage ?? 'Login failed');
      setState(ViewState.idle);
    }
  }
}
