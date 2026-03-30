import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/ui/screens/profile/profile_view_model.dart';
import 'package:sheduling_app/student/ui/screens/profile/components/student_edit_profile.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          final student = model.authServices.studentUser;
          return Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Student Profile",
                  style: styleB25.copyWith(color: secondaryColor, fontSize: 22.sp)),
              elevation: 0,
              backgroundColor: whiteColor,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _profileHeader(student),
                  const SizedBox(height: 30),
                  _profileInfoSection(student),
                  const SizedBox(height: 30),
                  _actionSection(model),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _profileHeader(student) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60.r,
          backgroundColor: secondaryColor.withOpacity(0.1),
          child: Icon(Icons.person, size: 60.r, color: secondaryColor),
        ),
        const SizedBox(height: 15),
        Text(student.fullName ?? "Student Name", style: styleB20),
        Text(student.email ?? "student@email.com",
            style: styleN14.copyWith(color: Colors.grey)),
      ],
    );
  }

  Widget _profileInfoSection(student) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _infoRow(Icons.school_outlined, "Department", student.department ?? "N/A"),
          const Divider(),
          _infoRow(Icons.class_outlined, "Section", student.section ?? "N/A"),
          const Divider(),
          _infoRow(Icons.calendar_today_outlined, "Semester", "Semester ${student.semester ?? 'N/A'}"),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: secondaryColor, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: styleN12.copyWith(color: Colors.grey)),
                Text(value, style: styleB14.copyWith(color: blackColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionSection(ProfileViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _actionTile(Icons.edit_outlined, "Edit Profile", () => Get.to(() => const StudentEditProfile())),
          _actionTile(Icons.info_outline, "About Us", () {}),
          _actionTile(Icons.logout_rounded, "Log Out", () => model.logout(), isDanger: true),
        ],
      ),
    );
  }

  Widget _actionTile(IconData icon, String title, VoidCallback onTap, {bool isDanger = false}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDanger ? Colors.red : blackColor, size: 22),
      title: Text(title, style: styleB14.copyWith(color: isDanger ? Colors.red : blackColor)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      contentPadding: EdgeInsets.zero,
    );
  }
}
