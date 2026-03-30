import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/student/auth/login/student_login_view_model.dart';
import 'package:sheduling_app/student/auth/signup/student_signup_screen.dart';
import 'package:sheduling_app/teacher/core/constants/app_assets.dart';
import 'package:sheduling_app/teacher/core/constants/auth_field_decoration.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/buttons/custom_back_button.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/buttons/custom_button.dart';
import 'package:sheduling_app/common/welcome_screen.dart';

class StudentSignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  StudentSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StudentSignInViewModel(),
      child: Consumer<StudentSignInViewModel>(
        builder: (context, model, child) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.busy,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      _header(),
                      SizedBox(height: 30.h),
                      Text(
                        "Please enter your email and password to sign in",
                        style: styleN16.copyWith(color: blackColor),
                      ),
                      SizedBox(height: 50.h),
                      
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.trim().isEmpty) return "Please enter your email";
                          return null;
                        },
                        onChanged: (value) => model.studentUser.email = value.trim(),
                        decoration: authFieldDecoration.copyWith(hintText: 'Email address'),
                      ),
                      SizedBox(height: 20.h),
                      
                      TextFormField(
                        obscureText: model.isShowPassword,
                        onChanged: (value) => model.studentUser.password = value.trim(),
                        validator: (value) {
                          if (value!.trim().isEmpty) return "Please enter your password";
                          return null;
                        },
                        decoration: authFieldDecoration.copyWith(
                          suffixIcon: GestureDetector(
                            onTap: () => model.toggleShowPassword(),
                            child: Icon(
                              model.isShowPassword ? Icons.visibility_off : Icons.visibility,
                              color: primaryColor,
                            ),
                          ),
                          hintText: 'Password',
                        ),
                      ),
                      SizedBox(height: 30.h),
                      
                      CustomButton(
                        name: 'Sign In',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            model.signInWithEmailAndPassword();
                          }
                        },
                        textColor: lightPinkColor,
                      ),
                      
                      SizedBox(height: 30.h),
                      _orDivider(),
                      SizedBox(height: 30.h),
                      _googleSignInButton(),
                      
                      SizedBox(height: 20.h),
                      _signupLink(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomBackButton(onPressed: () => Get.offAll(() => WelcomeScreen())),
        SizedBox(width: 20.w),
        Text(
          "Student Sign In",
          style: styleB25.copyWith(color: blackColor, fontSize: 26.sp),
        ),
      ],
    );
  }

  Widget _orDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(AppAssets.dividerImageLeft, color: primaryColor, scale: 2.9),
        Text("OR", style: styleB14.copyWith(fontSize: 12)),
        Image.asset(AppAssets.dividerImageRight, color: primaryColor, scale: 2.9),
      ],
    );
  }

  Widget _googleSignInButton() {
    return Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: secondaryColor),
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.googleLogo, scale: 3),
          SizedBox(width: 20.w),
          Text("Sign In Using Google", style: styleB16.copyWith(color: blackColor)),
        ],
      ),
    );
  }

  Widget _signupLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("New here?", style: styleB14.copyWith(fontWeight: FontWeight.w400)),
        TextButton(
          onPressed: () => Get.to(() => StudentSignUpScreen()),
          child: Text("Sign Up", style: styleB16.copyWith(color: secondaryColor)),
        )
      ],
    );
  }
}
