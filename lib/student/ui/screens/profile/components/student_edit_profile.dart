import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/app_constants.dart';
import 'package:sheduling_app/teacher/core/constants/auth_field_decoration.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, model, child) => Scaffold(
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
        body: model.state == ViewState.busy
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _profileHeader(model.authServices.studentUser),
                        const SizedBox(height: 30),
                        
                        TextFormField(
                          controller: nameController,
                          validator: (value) => value!.isEmpty ? "Required" : null,
                          decoration: authFieldDecoration.copyWith(hintText: 'Full Name'),
                        ),
                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          value: selectedDepartment,
                          validator: (value) => value == null ? "Required" : null,
                          decoration: authFieldDecoration.copyWith(hintText: 'Select Department'),
                          items: AppConstants.departments.map((dept) {
                            return DropdownMenuItem(value: dept, child: Text(dept));
                          }).toList(),
                          onChanged: (val) => selectedDepartment = val,
                        ),
                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          value: selectedSection,
                          validator: (value) => value == null ? "Required" : null,
                          decoration: authFieldDecoration.copyWith(hintText: 'Select Section'),
                          items: AppConstants.sections.map((sec) {
                            return DropdownMenuItem(value: sec, child: Text(sec));
                          }).toList(),
                          onChanged: (val) => selectedSection = val,
                        ),
                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          value: selectedSemester,
                          validator: (value) => value == null ? "Required" : null,
                          decoration: authFieldDecoration.copyWith(hintText: 'Select Semester'),
                          items: AppConstants.semesters.map((sem) {
                            return DropdownMenuItem(value: sem, child: Text("Semester $sem"));
                          }).toList(),
                          onChanged: (val) => selectedSemester = val,
                        ),
                        const SizedBox(height: 40),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final updatedStudent = StudentUser(
                                id: model.authServices.studentUser.id,
                                email: model.authServices.studentUser.email,
                                fullName: nameController.text.trim(),
                                department: selectedDepartment,
                                section: selectedSection,
                                semester: selectedSemester,
                              );
                              
                              bool success = await model.updateStudentProfile(updatedStudent);
                              if (success) {
                                Get.back();
                                Get.snackbar("Success", "Profile updated successfully");
                              } else {
                                Get.snackbar("Error", "Failed to update profile");
                              }
                            }
                          },
                          child: Text(
                            'SAVE CHANGES',
                            style: styleB16.copyWith(color: whiteColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _profileHeader(student) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 70.r,
            backgroundColor: secondaryColor.withOpacity(0.1),
            child: Icon(Icons.person, size: 70.r, color: secondaryColor),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: secondaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.camera_alt, color: whiteColor, size: 20),
          ),
        ],
      ),
    );
  }
}
