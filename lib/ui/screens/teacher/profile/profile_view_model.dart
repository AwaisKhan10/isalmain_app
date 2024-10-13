import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sheduling_app/core/enums/view_state.dart';
import 'package:sheduling_app/core/services/auth_services.dart';
import 'package:sheduling_app/core/view_model/view_model.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/ui/screens/student/auth/sign_in/sign_in_screens.dart';
import 'package:sheduling_app/ui/screens/teacher/auth/sign_in/sign_in_screen.dart';
import 'package:sheduling_app/ui/screens/teacher/auth/sign_up/sign_up_screen.dart';

class ProfileViewModel extends BaseViewModel {
  final AuthServices _authServices = locator<AuthServices>();
  void logout() {
    setState(ViewState.busy);
    _authServices.logout();
    Get.offAll(SignInScreen());
    setState(ViewState.idle);
  }
}
