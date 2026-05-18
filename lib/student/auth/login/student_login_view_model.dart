import 'package:get/get.dart';
import 'package:sheduling_app/common/app_snackbar.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/model/custom_auth_result.dart';
import 'package:sheduling_app/teacher/core/model/student_user.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/student/ui/screens/root/student_root_screen.dart';

class StudentSignInViewModel extends BaseViewModel {
  final AuthServices _authServices = locator<AuthServices>();
  CustomAuthResult customAuthResult = CustomAuthResult();

  final StudentUser studentUser = StudentUser();
  bool isShowPassword = true;

  toggleShowPassword() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  void signInWithEmailAndPassword() async {
    if (studentUser.email == null || studentUser.password == null) {
      AppSnackbar.error('Please enter email and password');
      return;
    }

    setState(ViewState.busy);

    customAuthResult = await _authServices.loginWithEmailandPassword(
      email: studentUser.email,
      password: studentUser.password,
    );

    if (customAuthResult.status!) {
      if (!_authServices.isTeacher) {
        _authServices.isLogin = true;
        AppSnackbar.success('Welcome back!');
        Get.offAll(() => const StudentRootScreen());
      } else {
        AppSnackbar.error('This account is registered as a Teacher');
        setState(ViewState.idle);
      }
    } else {
      AppSnackbar.error(customAuthResult.errorMessage ?? 'Login failed');
      setState(ViewState.idle);
    }
  }
}
