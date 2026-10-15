import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sheduling_app/common/app_snackbar.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/model/custom_auth_result.dart';
import 'package:sheduling_app/teacher/core/model/teacher_user.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';
import 'package:sheduling_app/teacher/ui/screens/root/root_screen.dart';

class CompleteTeacherProfileViewModel extends BaseViewModel {
  final AuthServices _authServices = locator<AuthServices>();
  final TeacherUser teacherUser = TeacherUser();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController subjectsController = TextEditingController();

  CompleteTeacherProfileViewModel() {
    final existing = _authServices.teacherUser;
    teacherUser.id = existing.id ?? _authServices.user?.uid;
    teacherUser.email = existing.email ?? _authServices.user?.email;
    teacherUser.fullName =
        existing.fullName ?? _authServices.user?.displayName;
    teacherUser.profileImageUrl =
        existing.profileImageUrl ?? _authServices.user?.photoURL;
    nameController.text = teacherUser.fullName ?? '';
    emailController.text = teacherUser.email ?? '';
  }

  Future<void> cancelGoogleSignUp() async {
    await _authServices.logout();
    Get.back();
  }

  Future<void> saveProfile() async {
    teacherUser.fullName = nameController.text.trim();
    teacherUser.email = emailController.text.trim();
    teacherUser.phoneNo = phoneController.text.trim();
    teacherUser.qualification = qualificationController.text.trim();
    teacherUser.subjects = subjectsController.text.trim();

    if (teacherUser.department == null ||
        teacherUser.gender == null ||
        teacherUser.fullName!.isEmpty ||
        teacherUser.phoneNo!.isEmpty ||
        teacherUser.qualification!.isEmpty ||
        teacherUser.subjects!.isEmpty) {
      AppSnackbar.error('Please fill all required signup fields');
      return;
    }

    setState(ViewState.busy);
    final CustomAuthResult result =
        await _authServices.completeGoogleTeacherProfile(teacherUser);
    if (result.status == true) {
      AppSnackbar.success('Account created successfully');
      Get.offAll(() => const RootScreen());
    } else {
      AppSnackbar.error(result.errorMessage ?? 'Could not complete profile');
      setState(ViewState.idle);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    qualificationController.dispose();
    subjectsController.dispose();
    super.dispose();
  }
}
