import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/core/constants/app_assets.dart';
import 'package:sheduling_app/core/constants/auth_field_decoration.dart';
import 'package:sheduling_app/core/constants/colors.dart';
import 'package:sheduling_app/core/constants/text_style.dart';
import 'package:sheduling_app/core/enums/view_state.dart';
import 'package:sheduling_app/custom_widgets/buttons/custom_back_button.dart';
import 'package:sheduling_app/custom_widgets/buttons/custom_button.dart';
import 'package:sheduling_app/custom_widgets/custom_routes/navigate_from_right.dart';
import 'package:sheduling_app/ui/screens/teacher/auth/sign_in/sign_in_screen.dart';
import 'package:sheduling_app/ui/screens/teacher/auth/sign_up/sign_up_view_model.dart';
import 'package:sheduling_app/ui/screens/teacher/auth/sign_up/teacher_information.dart';

class SignUpScreen extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  //final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(
        builder: (context, model, child) => ModalProgressHUD(
              inAsyncCall: model.state == ViewState.busy,
              child: Scaffold(
                ///
                /// Start Body
                ///
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          _header(),
                          SizedBox(
                            height: 30.h,
                          ),

                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "Please Fill these form fields with the following information",
                            style: styleN16.copyWith(color: blackColor),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          // TextFormField(
                          //   onChanged: (value) {
                          //     model.teacherUser.fullName = value.trim();
                          //   },
                          //   decoration: authFieldDecoration.copyWith(
                          //       hintText: 'Full Name'),
                          //   validator: (value) {
                          //     if (value!.trim().isEmpty) {
                          //       return "Please enter your Full Name";
                          //     } else if (!RegExp(r'^[a-z0-9_\.]{3,20}$')
                          //         .hasMatch(value)) {
                          //       return "Username must be 3-20 characters long, lowercase, and contain only letters, numbers, underscores (_) or periods (.)";
                          //     } else if (value.contains("..") ||
                          //         value.contains("__")) {
                          //       return "Full Name cannot contain consecutive speacial characters";
                          //     } else {
                          //       return null;
                          //     }
                          //   },
                          // ),
                          TextFormField(
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Please enter you full name";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              model.teacherUser.fullName = value.trim();
                            },
                            decoration: authFieldDecoration.copyWith(
                                hintText: "Full Name"),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "please enter your email";
                              }
                            },
                            onChanged: (value) {
                              model.teacherUser.email = value.trim();
                            },
                            decoration: authFieldDecoration.copyWith(
                                hintText: 'Email address'),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "please enter your Phone number";
                              }
                            },
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              model.teacherUser.phoneNo = value.trim();
                            },
                            decoration: authFieldDecoration.copyWith(
                                hintText: 'Phone Number'),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          TextFormField(
                            obscureText: model.isShowpassword ? true : false,
                            onChanged: (value) {
                              model.teacherUser.password = value.trim();
                            },
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Please enter your password";
                              } else if (value!.trim().length < 7) {
                                return "Password must be atleast 7 characters";
                              } else {
                                return null;
                              }
                            },
                            decoration: authFieldDecoration.copyWith(
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      model.toggleShowPassword();
                                    },
                                    child: Icon(
                                      model.isShowpassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: primaryColor,
                                    )),
                                hintText: 'Password'),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),

                          ///
                          /// Custom Button
                          ///
                          CustomButton(
                              name: 'Next',
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  model.signUpwithEmailandPassword();
                                }
                              },
                              textColor: lightPinkColor),

                          ///
                          /// Divider
                          ///
                          _divider(),

                          ///
                          /// Sign In Google User
                          ///
                          _signWithGoogleUser(),
                          SizedBox(
                            height: 20.h,
                          ),

                          ///
                          /// Already have an account
                          ///
                          _alreadyHaveAnAccount(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}

_divider() {
  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          AppAssets.dividerImageLeft,
          color: primaryColor,
          scale: 2.9,
        ),
        Text(
          "OR",
          style: styleB14.copyWith(fontSize: 12),
        ),
        Image.asset(AppAssets.dividerImageRight,
            color: primaryColor, scale: 2.9),
      ],
    ),
  );
}

_alreadyHaveAnAccount(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Already have Account?",
        style: styleB14.copyWith(fontWeight: FontWeight.w400),
      ),
      TextButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.pushReplacement(
              context, NavigationFromRightRoute(page: SignInScreen()));
        },
        child: Text(
          "Sign In",
          style: styleB16.copyWith(
            color: secondaryColor,
          ),
        ),
      )
    ],
  );
}

_signWithGoogleUser() {
  return Container(
    padding: const EdgeInsets.all(15),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        border: Border.all(width: 1, color: secondaryColor),
        color: whiteColor,
        borderRadius: BorderRadius.circular(16)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          AppAssets.googleLogo,
          scale: 3,
        ),
        SizedBox(
          width: 20.w,
        ),
        Text(
          "Sign In Using Google",
          style: styleB16.copyWith(color: blackColor),
        ),
      ],
    ),
  );
}

_header() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CustomBackButton(
        onPressed: () {
          Get.back();
        },
      ),
      SizedBox(
        width: 20.w,
      ),
      Text(
        "Sign Up",
        style: styleB25.copyWith(color: blackColor, fontSize: 30.sp),
      ),
    ],
  );
}
