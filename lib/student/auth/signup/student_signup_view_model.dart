import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  // controllers for textfields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // this is the instance of model class
  StudentUser studentUser = StudentUser();
  bool isShowpassword = true;

  // for the obscure toggle icon
  toggleShowPassword() {
    isShowpassword = !isShowpassword;
    notifyListeners();
  }

  void signUpStudent() async {
    setState(ViewState.busy);

    if (studentUser.department == null ||
        studentUser.section == null ||
        studentUser.semester == null) {
      Get.snackbar("Error", "Please select department, section and semester");
      setState(ViewState.idle);
      return;
    }

    customAuthResult = await _authservice.signUpStudent(studentUser);
    if (customAuthResult.status!) {
      _authservice.isLogin = true;
      _authservice.isTeacher = false;
      Get.snackbar('Register', 'Student Registered Successfully');
      Get.offAll(() => const StudentRootScreen());
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
