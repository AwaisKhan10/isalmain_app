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

class TeacherSignUpViewModel extends BaseViewModel {
  final _authservice = locator<AuthServices>();

  CustomAuthResult customAuthResult = CustomAuthResult();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  TeacherUser teacherUser = TeacherUser();
  bool isShowpassword = true;

  toggleShowPassword() {
    isShowpassword = !isShowpassword;
    notifyListeners();
  }

  void signUpwithEmailandPassword() async {
    setState(ViewState.busy);

    customAuthResult = await _authservice.signUpTeacher(teacherUser);
    if (customAuthResult.status!) {
      _authservice.isLogin = true;
      AppSnackbar.success('Account created successfully');
      Get.offAll(() => const RootScreen());
    } else {
      AppSnackbar.error(customAuthResult.errorMessage ?? 'Registration failed');
      setState(ViewState.idle);
    }
  }
}
