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
import 'package:sheduling_app/teacher/ui/screens/auth/sign_up/complete_teacher_profile_screen.dart';

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

  Future<void> signInWithGoogle() async {
    setState(ViewState.busy);
    customAuthResult =
        await _authServices.signInWithGoogle(asTeacher: true);

    if (customAuthResult.status == true) {
      if (customAuthResult.needsProfileCompletion) {
        setState(ViewState.idle);
        Get.to(() => CompleteTeacherProfileScreen());
        return;
      }
      if (_authServices.isTeacher) {
        _authServices.isLogin = true;
        AppSnackbar.success('Logged in successfully');
        Get.offAll(() => const RootScreen());
      } else {
        AppSnackbar.error('This account is registered as a student');
        setState(ViewState.idle);
      }
    } else {
      final message = customAuthResult.errorMessage ?? 'Google sign in failed';
      if (!message.toLowerCase().contains('cancel')) {
        AppSnackbar.error(message);
      }
      setState(ViewState.idle);
    }
  }
}
