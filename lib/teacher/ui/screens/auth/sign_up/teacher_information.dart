// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/app_assets.dart';
import 'package:sheduling_app/teacher/core/constants/auth_field_decoration.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/model/teacher/teacher_user.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/buttons/custom_back_button.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/buttons/custom_button.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/custom_routes/navigate_from_right.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/teacher/ui/screens/auth/sign_in/sign_in_screen.dart';
import 'package:sheduling_app/teacher/ui/screens/auth/sign_up/sign_up_view_model.dart';

class TeacherInformation extends StatelessWidget {
  final DatabaseServices db = locator<DatabaseServices>();
  final TeacherUser teacherUser = TeacherUser();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherSignUpViewModel>(
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
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(13.0.sp),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 3.0),
                                      gradient: const LinearGradient(colors: [
                                        primaryColor,
                                        secondaryColor
                                      ])),
                                  child: CircleAvatar(
                                    radius: 65.r,
                                    backgroundColor: whiteColor,
                                    child: CircleAvatar(
                                      backgroundColor: greyColor,
                                      radius: 60.r,
                                      child: Icon(
                                        Icons.person,
                                        color: whiteColor,
                                        size: 60.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, bottom: 10),
                                    child: CircleAvatar(
                                      backgroundColor: whiteColor,
                                      radius: 20.r,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 25.sp,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "please enter your Department";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              model.teacherUser.department = value.trim();
                            },
                            decoration: authFieldDecoration.copyWith(
                                hintText: 'Department'),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "please enter your Qulification";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              model.teacherUser.qualification = value.trim();
                            },
                            decoration: authFieldDecoration.copyWith(
                                hintText: 'Qualification'),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "please enter your Subject Teach";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              model.teacherUser.subjects = value.trim();
                            },
                            decoration: authFieldDecoration.copyWith(
                                hintText: 'Subjects Teach'),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "please enter your Gender";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              model.teacherUser.gender = value.trim();
                            },
                            decoration: authFieldDecoration.copyWith(
                                hintText: 'Gender'),
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
                          // _signWithGoogleUser(),
                          // SizedBox(
                          //   height: 20.h,
                          // ),

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
              context, NavigationFromRightRoute(page: TeacherSignInScreen()));
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
        "Techer Information",
        style: styleB25.copyWith(color: blackColor, fontSize: 30.sp),
      ),
    ],
  );
}
