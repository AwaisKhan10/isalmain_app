import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheduling_app/common/app_snackbar.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/student/ui/screens/root/student_root_screen.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/model/custom_auth_result.dart';
import 'package:sheduling_app/teacher/core/model/student_user.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';

class CompleteStudentProfileViewModel extends BaseViewModel {
  final AuthServices _authServices = locator<AuthServices>();
  final StudentUser studentUser = StudentUser();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? selectedDepartment;
  String? selectedField;

  CompleteStudentProfileViewModel() {
    final existing = _authServices.studentUser;
    studentUser.id = existing.id ?? _authServices.user?.uid;
    studentUser.email = existing.email ?? _authServices.user?.email;
    studentUser.fullName =
        existing.fullName ?? _authServices.user?.displayName;
    studentUser.profileImageUrl =
        existing.profileImageUrl ?? _authServices.user?.photoURL;
    nameController.text = studentUser.fullName ?? '';
    emailController.text = studentUser.email ?? '';
  }

  void setDepartment(String? department) {
    selectedDepartment = department;
    selectedField = null;
    studentUser.department = department;
    studentUser.field = null;
    notifyListeners();
  }

  void setField(String? field) {
    selectedField = field;
    studentUser.field = field;
    notifyListeners();
  }

  Future<void> cancelGoogleSignUp() async {
    await _authServices.logout();
    Get.back();
  }

  Future<void> saveProfile() async {
    studentUser.fullName = nameController.text.trim();
    studentUser.email = emailController.text.trim();

    if (studentUser.fullName!.isEmpty ||
        studentUser.department == null ||
        studentUser.field == null ||
        studentUser.section == null ||
        studentUser.semester == null) {
      AppSnackbar.error(
          'Please fill all required signup fields (name, department, field, section, semester)');
      return;
    }

    setState(ViewState.busy);
    final CustomAuthResult result =
        await _authServices.completeGoogleStudentProfile(studentUser);
    if (result.status == true) {
      AppSnackbar.success('Account created successfully');
      Get.offAll(() => const StudentRootScreen());
    } else {
      AppSnackbar.error(result.errorMessage ?? 'Could not complete profile');
      setState(ViewState.idle);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
