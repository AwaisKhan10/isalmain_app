import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/app_constants.dart';
import 'package:sheduling_app/teacher/core/constants/auth_field_decoration.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/buttons/custom_back_button.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/buttons/custom_button.dart';
import 'package:sheduling_app/student/auth/signup/student_signup_view_model.dart';

class StudentSignUpScreen extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();

  StudentSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StudentSignUpViewModel(),
      child: Consumer<StudentSignUpViewModel>(
        builder: (context, model, child) => ModalProgressHUD(
          inAsyncCall: model.state == ViewState.busy,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      _header(),
                      SizedBox(height: 30.h),
                      Text(
                        "Student Registration",
                        style: styleN16.copyWith(color: blackColor),
                      ),
                      SizedBox(height: 30.h),
                      
                      TextFormField(
                        validator: (value) {
                          if (value!.trim().isEmpty) return "Please enter your full name";
                          return null;
                        },
                        onChanged: (value) => model.studentUser.fullName = value.trim(),
                        decoration: authFieldDecoration.copyWith(hintText: "Full Name"),
                      ),
                      SizedBox(height: 20.h),
                      
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
                      
                      DropdownButtonFormField<String>(
                        decoration: authFieldDecoration.copyWith(hintText: 'Select Department'),
                        items: AppConstants.departments.map((dept) {
                          return DropdownMenuItem(value: dept, child: Text(dept));
                        }).toList(),
                        onChanged: (val) => model.studentUser.department = val,
                        validator: (value) => value == null ? "Required" : null,
                      ),
                      SizedBox(height: 20.h),
                      
                      DropdownButtonFormField<String>(
                        decoration: authFieldDecoration.copyWith(hintText: 'Select Section'),
                        items: AppConstants.sections.map((sec) {
                          return DropdownMenuItem(value: sec, child: Text(sec));
                        }).toList(),
                        onChanged: (val) => model.studentUser.section = val,
                        validator: (value) => value == null ? "Required" : null,
                      ),
                      SizedBox(height: 20.h),
                      
                      DropdownButtonFormField<String>(
                        decoration: authFieldDecoration.copyWith(hintText: 'Select Semester'),
                        items: AppConstants.semesters.map((sem) {
                          return DropdownMenuItem(value: sem, child: Text("Semester $sem"));
                        }).toList(),
                        onChanged: (val) => model.studentUser.semester = val,
                        validator: (value) => value == null ? "Required" : null,
                      ),
                      SizedBox(height: 20.h),
                      
                      TextFormField(
                        obscureText: model.isShowpassword,
                        onChanged: (value) => model.studentUser.password = value.trim(),
                        validator: (value) {
                          if (value!.trim().isEmpty) return "Please enter your password";
                          if (value.trim().length < 6) return "Min 6 characters required";
                          return null;
                        },
                        decoration: authFieldDecoration.copyWith(
                          suffixIcon: GestureDetector(
                            onTap: () => model.toggleShowPassword(),
                            child: Icon(
                              model.isShowpassword ? Icons.visibility_off : Icons.visibility,
                              color: primaryColor,
                            ),
                          ),
                          hintText: 'Password',
                        ),
                      ),
                      SizedBox(height: 30.h),
                      
                      CustomButton(
                        name: 'Register',
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            model.signUpStudent();
                          }
                        },
                        textColor: lightPinkColor,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?",
                              style: styleB14.copyWith(
                                  fontWeight: FontWeight.w400)),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text("Sign In",
                                style: styleB16.copyWith(color: secondaryColor)),
                          )
                        ],
                      ),
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
        CustomBackButton(onPressed: () => Get.back()),
        SizedBox(width: 20.w),
        Text(
          "Student Sign Up",
          style: styleB25.copyWith(color: blackColor, fontSize: 26.sp),
        ),
      ],
    );
  }
}
