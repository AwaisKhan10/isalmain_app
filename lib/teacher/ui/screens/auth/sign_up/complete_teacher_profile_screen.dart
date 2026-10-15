import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/app_constants.dart';
import 'package:sheduling_app/teacher/core/constants/auth_field_decoration.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/buttons/custom_back_button.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/buttons/custom_button.dart';
import 'package:sheduling_app/teacher/ui/screens/auth/sign_up/complete_teacher_profile_view_model.dart';

class CompleteTeacherProfileScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  CompleteTeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompleteTeacherProfileViewModel(),
      child: Consumer<CompleteTeacherProfileViewModel>(
        builder: (context, model, child) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) model.cancelGoogleSignUp();
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          CustomBackButton(
                              onPressed: model.cancelGoogleSignUp),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Text(
                              'Complete Teacher Profile',
                              style: styleB25.copyWith(
                                  color: blackColor, fontSize: 22.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Google sign in successful. Please enter the remaining signup details to create your teacher account.',
                        style: styleN16.copyWith(color: blackColor),
                      ),
                      SizedBox(height: 30.h),
                      TextFormField(
                        controller: model.nameController,
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Please enter your full name'
                            : null,
                        decoration:
                            authFieldDecoration.copyWith(hintText: 'Full Name'),
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: model.emailController,
                        enabled: false,
                        decoration: authFieldDecoration.copyWith(
                            hintText: 'Email address'),
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: model.phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Please enter your phone number'
                            : null,
                        decoration: authFieldDecoration.copyWith(
                            hintText: 'Phone Number'),
                      ),
                      SizedBox(height: 20.h),
                      DropdownButtonFormField<String>(
                        icon: dropdownFieldIcon,
                        validator: (value) =>
                            value == null ? 'Required' : null,
                        decoration: authFieldDecoration.copyWith(
                            hintText: 'Select Department'),
                        items: AppConstants.departments
                            .map((dept) => DropdownMenuItem(
                                value: dept, child: Text(dept)))
                            .toList(),
                        onChanged: (val) =>
                            model.teacherUser.department = val,
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: model.qualificationController,
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Required'
                            : null,
                        decoration: authFieldDecoration.copyWith(
                            hintText: 'Qualification (e.g. Masters)'),
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: model.subjectsController,
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Required'
                            : null,
                        decoration: authFieldDecoration.copyWith(
                            hintText: 'Subjects (e.g. Maths, CS)'),
                      ),
                      SizedBox(height: 20.h),
                      DropdownButtonFormField<String>(
                        icon: dropdownFieldIcon,
                        validator: (value) =>
                            value == null ? 'Required' : null,
                        decoration: authFieldDecoration.copyWith(
                            hintText: 'Select Gender'),
                        items: ['Male', 'Female', 'Other']
                            .map((g) => DropdownMenuItem(
                                value: g, child: Text(g)))
                            .toList(),
                        onChanged: (val) => model.teacherUser.gender = val,
                      ),
                      SizedBox(height: 30.h),
                      CustomButton(
                        name: 'Complete Profile',
                        isLoading: model.state == ViewState.busy,
                        textColor: lightPinkColor,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            model.saveProfile();
                          }
                        },
                      ),
                      SizedBox(height: 30.h),
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
}
