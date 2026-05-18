import 'dart:io';

import 'package:get/get.dart';
import 'package:sheduling_app/common/app_snackbar.dart';
import 'package:sheduling_app/common/welcome_screen.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/model/student_user.dart';
import 'package:sheduling_app/teacher/core/model/teacher_user.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/core/services/storage_service.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';
import 'package:sheduling_app/locator.dart';

class ProfileViewModel extends BaseViewModel {
  final authServices = locator<AuthServices>();
  final dataBaseServices = locator<DatabaseServices>();
  final storageService = locator<StorageService>();

  bool isSavingProfile = false;

  Future<void> logout() async {
    setState(ViewState.busy);
    await authServices.logout();
    AppSnackbar.info('You have been logged out');
    Get.offAll(() => WelcomeScreen());
    setState(ViewState.idle);
  }

  Future<bool> updateTeacherProfile(
    TeacherUser updatedUser, {
    File? profileImage,
  }) async {
    isSavingProfile = true;
    notifyListeners();

    if (profileImage != null && updatedUser.id != null) {
      final upload = await storageService.uploadProfileImage(
        userId: updatedUser.id!,
        imageFile: profileImage,
      );
      if (!upload.isSuccess) {
        AppSnackbar.error(upload.errorMessage ?? 'Failed to upload profile photo');
        isSavingProfile = false;
        notifyListeners();
        return false;
      }
      updatedUser.profileImageUrl = upload.downloadUrl;
    }

    final success = await dataBaseServices.updateTeacherUser(updatedUser);
    if (success) {
      authServices.teacherUser = updatedUser;
    }

    isSavingProfile = false;
    notifyListeners();
    return success;
  }

  Future<bool> updateStudentProfile(
    StudentUser updatedUser, {
    File? profileImage,
  }) async {
    isSavingProfile = true;
    notifyListeners();

    if (profileImage != null && updatedUser.id != null) {
      final upload = await storageService.uploadProfileImage(
        userId: updatedUser.id!,
        imageFile: profileImage,
      );
      if (!upload.isSuccess) {
        AppSnackbar.error(upload.errorMessage ?? 'Failed to upload profile photo');
        isSavingProfile = false;
        notifyListeners();
        return false;
      }
      updatedUser.profileImageUrl = upload.downloadUrl;
    }

    final success = await dataBaseServices.updateStudentUser(updatedUser);
    if (success) {
      authServices.studentUser = updatedUser;
    }

    isSavingProfile = false;
    notifyListeners();
    return success;
  }
}
