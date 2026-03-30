import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';
import 'package:sheduling_app/locator.dart';

import 'package:sheduling_app/common/welcome_screen.dart';
import 'package:sheduling_app/teacher/core/model/student_user.dart';
import 'package:sheduling_app/teacher/core/model/teacher_user.dart';

class ProfileViewModel extends BaseViewModel {
  final authServices = locator<AuthServices>();
  final dataBaseServices = locator<DatabaseServices>();

  void logout() {
    setState(ViewState.busy);
    authServices.logout();
    Get.offAll(() => WelcomeScreen());
    setState(ViewState.idle);
  }

  Future<bool> updateTeacherProfile(TeacherUser updatedUser) async {
    setState(ViewState.busy);
    bool success = await dataBaseServices.updateTeacherUser(updatedUser);
    if (success) {
      authServices.teacherUser = updatedUser;
      notifyListeners();
    }
    setState(ViewState.idle);
    return success;
  }

  Future<bool> updateStudentProfile(StudentUser updatedUser) async {
    setState(ViewState.busy);
    bool success = await dataBaseServices.updateStudentUser(updatedUser);
    if (success) {
      authServices.studentUser = updatedUser;
      notifyListeners();
    }
    setState(ViewState.idle);
    return success;
  }
}
