import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/common/app_snackbar.dart';
import 'package:sheduling_app/common/profile_image_picker.dart';
import 'package:sheduling_app/common/widgets/profile_avatar.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/buttons/custom_button.dart';
import 'package:sheduling_app/teacher/core/constants/app_constants.dart';
import 'package:sheduling_app/teacher/core/constants/auth_field_decoration.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/core/model/student_user.dart';
import 'package:sheduling_app/teacher/ui/screens/profile/profile_view_model.dart';

class StudentEditProfile extends StatefulWidget {
  const StudentEditProfile({super.key});

  @override
  State<StudentEditProfile> createState() => _StudentEditProfileState();
}

class _StudentEditProfileState extends State<StudentEditProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  String? selectedDepartment;
  String? selectedSection;
  String? selectedSemester;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    final model = Provider.of<ProfileViewModel>(context, listen: false);
    final student = model.authServices.studentUser;

    nameController = TextEditingController(text: student.fullName);
    selectedDepartment = student.department;
    selectedSection = student.section;
    selectedSemester = student.semester;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final file = await ProfileImagePicker.pick(context);
    if (file != null) {
      setState(() => _pickedImage = file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, model, child) {
        final student = model.authServices.studentUser;
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            backgroundColor: whiteColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: secondaryColor),
              onPressed: () => Get.back(),
            ),
            title: Text(
              "Edit Profile",
              style: styleB25.copyWith(color: secondaryColor, fontSize: 24.sp),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: ProfileAvatar(
                        radius: 70.r,
                        imageUrl: student.profileImageUrl,
                        localImage: _pickedImage,
                        showCameraBadge: true,
                        onTap: _pickProfileImage,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap photo to change',
                      style: styleN12.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: nameController,
                      validator: (value) => value!.isEmpty ? "Required" : null,
                      decoration: authFieldDecoration.copyWith(hintText: 'Full Name'),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      icon: dropdownFieldIcon,
                      value: selectedDepartment,
                      validator: (value) => value == null ? "Required" : null,
                      decoration: authFieldDecoration.copyWith(hintText: 'Select Department'),
                      items: AppConstants.departments.map((dept) {
                        return DropdownMenuItem(value: dept, child: Text(dept));
                      }).toList(),
                      onChanged: (val) => setState(() => selectedDepartment = val),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      icon: dropdownFieldIcon,
                      value: selectedSection,
                      validator: (value) => value == null ? "Required" : null,
                      decoration: authFieldDecoration.copyWith(hintText: 'Select Section'),
                      items: AppConstants.sections.map((sec) {
                        return DropdownMenuItem(value: sec, child: Text(sec));
                      }).toList(),
                      onChanged: (val) => setState(() => selectedSection = val),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      icon: dropdownFieldIcon,
                      value: selectedSemester,
                      validator: (value) => value == null ? "Required" : null,
                      decoration: authFieldDecoration.copyWith(hintText: 'Select Semester'),
                      items: AppConstants.semesters.map((sem) {
                        return DropdownMenuItem(value: sem, child: Text("Semester $sem"));
                      }).toList(),
                      onChanged: (val) => setState(() => selectedSemester = val),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      name: 'Save Changes',
                      isLoading: model.isSavingProfile,
                      textColor: whiteColor,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final updatedStudent = StudentUser(
                            id: student.id,
                            email: student.email,
                            password: student.password,
                            profileImageUrl: student.profileImageUrl,
                            fullName: nameController.text.trim(),
                            department: selectedDepartment,
                            section: selectedSection,
                            semester: selectedSemester,
                            fcmToken: student.fcmToken,
                            isOnline: student.isOnline,
                          );

                          final success = await model.updateStudentProfile(
                            updatedStudent,
                            profileImage: _pickedImage,
                          );
                          if (success) {
                            Get.back();
                            AppSnackbar.success('Profile updated successfully');
                          } else {
                            AppSnackbar.error(
                              _pickedImage != null
                                  ? 'Failed to upload photo or update profile'
                                  : 'Failed to update profile',
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
