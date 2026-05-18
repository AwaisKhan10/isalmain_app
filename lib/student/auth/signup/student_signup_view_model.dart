import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheduling_app/common/app_snackbar.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/model/custom_auth_result.dart';
import 'package:sheduling_app/teacher/core/model/student_user.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/student/ui/screens/root/student_root_screen.dart';

class StudentSignUpViewModel extends BaseViewModel {
  final _authservice = locator<AuthServices>();

  CustomAuthResult customAuthResult = CustomAuthResult();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  StudentUser studentUser = StudentUser();
  bool isShowpassword = true;

  toggleShowPassword() {
    isShowpassword = !isShowpassword;
    notifyListeners();
  }

  void signUpStudent() async {
    if (studentUser.department == null ||
        studentUser.section == null ||
        studentUser.semester == null) {
      AppSnackbar.error('Please select department, section and semester');
      return;
    }

    setState(ViewState.busy);

    customAuthResult = await _authservice.signUpStudent(studentUser);
    if (customAuthResult.status!) {
      _authservice.isLogin = true;
      _authservice.isTeacher = false;
      AppSnackbar.success('Account created successfully');
      Get.offAll(() => const StudentRootScreen());
    } else {
      AppSnackbar.error(customAuthResult.errorMessage ?? 'Registration failed');
      setState(ViewState.idle);
    }
  }
}
