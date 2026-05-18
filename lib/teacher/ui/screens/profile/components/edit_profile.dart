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
import 'package:sheduling_app/teacher/core/model/teacher_user.dart';
import 'package:sheduling_app/teacher/ui/screens/profile/profile_view_model.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController qualificationController;
  late TextEditingController subjectsController;
  String? selectedDepartment;
  String? selectedGender;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    final model = Provider.of<ProfileViewModel>(context, listen: false);
    final teacher = model.authServices.teacherUser;

    nameController = TextEditingController(text: teacher.fullName);
    phoneController = TextEditingController(text: teacher.phoneNo);
    qualificationController = TextEditingController(text: teacher.qualification);
    subjectsController = TextEditingController(text: teacher.subjects);
    selectedDepartment = teacher.department;
    selectedGender = teacher.gender;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    qualificationController.dispose();
    subjectsController.dispose();
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
        final teacher = model.authServices.teacherUser;
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
                        imageUrl: teacher.profileImageUrl,
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
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty ? "Required" : null,
                      decoration: authFieldDecoration.copyWith(hintText: 'Phone Number'),
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
                    TextFormField(
                      controller: qualificationController,
                      validator: (value) => value!.isEmpty ? "Required" : null,
                      decoration: authFieldDecoration.copyWith(hintText: 'Qualification'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: subjectsController,
                      validator: (value) => value!.isEmpty ? "Required" : null,
                      decoration: authFieldDecoration.copyWith(hintText: 'Subjects (e.g. CS, Maths)'),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      icon: dropdownFieldIcon,
                      value: selectedGender,
                      validator: (value) => value == null ? "Required" : null,
                      decoration: authFieldDecoration.copyWith(hintText: 'Select Gender'),
                      items: ['Male', 'Female', 'Other'].map((g) {
                        return DropdownMenuItem(value: g, child: Text(g));
                      }).toList(),
                      onChanged: (val) => setState(() => selectedGender = val),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      name: 'Save Changes',
                      isLoading: model.isSavingProfile,
                      textColor: whiteColor,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final updatedTeacher = TeacherUser(
                            id: teacher.id,
                            email: teacher.email,
                            password: teacher.password,
                            profileImageUrl: teacher.profileImageUrl,
                            fullName: nameController.text.trim(),
                            phoneNo: phoneController.text.trim(),
                            department: selectedDepartment,
                            qualification: qualificationController.text.trim(),
                            subjects: subjectsController.text.trim(),
                            gender: selectedGender,
                            fcmToken: teacher.fcmToken,
                            isOnline: teacher.isOnline,
                          );

                          final success = await model.updateTeacherProfile(
                            updatedTeacher,
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
