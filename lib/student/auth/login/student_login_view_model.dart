import 'package:get/get.dart';
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
    setState(ViewState.busy);
    
    if (studentUser.email == null || studentUser.password == null) {
      Get.snackbar("Error", "Please enter email and password");
      setState(ViewState.idle);
      return;
    }

    customAuthResult = await _authServices.loginWithEmailandPassword(
      email: studentUser.email,
      password: studentUser.password,
    );

    if (customAuthResult.status!) {
      if (!_authServices.isTeacher) {
        _authServices.isLogin = true;
        Get.snackbar("Login", "Student Logged In Successfully");
        Get.offAll(() => const StudentRootScreen());
      } else {
        Get.snackbar("Error", "This account is registered as a Teacher");
        setState(ViewState.idle);
      }
    } else {
      Get.snackbar("Error", "${customAuthResult.errorMessage}");
      setState(ViewState.idle);
    }
  }
}
