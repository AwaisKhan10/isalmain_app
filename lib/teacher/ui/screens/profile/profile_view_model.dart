import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';
import 'package:sheduling_app/locator.dart';

import 'package:sheduling_app/teacher/ui/screens/auth/sign_in/sign_in_screen.dart';

class ProfileViewModel extends BaseViewModel {
  final authServices = locator<AuthServices>();
  final dataBaseServices = locator<DatabaseServices>();

  void logout() {
    setState(ViewState.busy);
    authServices.logout();
    Get.offAll(TeacherSignInScreen());
    setState(ViewState.idle);
  }
}
