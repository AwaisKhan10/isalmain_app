import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/ui/screens/profile/components/edit_profile.dart';
import 'package:sheduling_app/teacher/ui/screens/profile/profile_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          final teacher = model.authServices.teacherUser;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Teacher Profile",
                  style: styleB25.copyWith(
                      color: secondaryColor, fontSize: 22.sp)),
              elevation: 0,
              backgroundColor: whiteColor,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _profileHeader(teacher),
                  const SizedBox(height: 30),
                  _profileInfoSection(teacher),
                  const SizedBox(height: 20),
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

  Widget _profileHeader(teacher) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60.r,
          backgroundColor: secondaryColor.withOpacity(0.1),
          child: Icon(Icons.person, size: 60.r, color: secondaryColor),
        ),
        const SizedBox(height: 15),
        Text(teacher.fullName ?? "User Name", style: styleB20),
        Text(teacher.email ?? "user@email.com",
            style: styleN14.copyWith(color: Colors.grey)),
      ],
    );
  }

  Widget _profileInfoSection(teacher) {
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
          _infoRow(
              Icons.school_outlined, "Department", teacher.department ?? "N/A"),
          const Divider(),
          _infoRow(Icons.workspace_premium_outlined, "Qualification",
              teacher.qualification ?? "N/A"),
          const Divider(),
          _infoRow(Icons.book_outlined, "Subjects", teacher.subjects ?? "N/A"),
          const Divider(),
          _infoRow(Icons.person_outline, "Gender", teacher.gender ?? "N/A"),
          const Divider(),
          _infoRow(
              Icons.phone_android_outlined, "Phone", teacher.phoneNo ?? "N/A"),
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
          _actionTile(Icons.edit_outlined, "Edit Profile",
              () => Get.to(() => const EditProfile())),
          _actionTile(Icons.description_outlined, "Terms & Conditions", () {}),
          _actionTile(Icons.info_outline, "About Us", () {}),
          _actionTile(Icons.logout_rounded, "Log Out", () => model.logout(),
              isDanger: true),
        ],
      ),
    );
  }

  Widget _actionTile(IconData icon, String title, VoidCallback onTap,
      {bool isDanger = false}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDanger ? Colors.red : blackColor, size: 22),
      title: Text(title,
          style: styleB14.copyWith(color: isDanger ? Colors.red : blackColor)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      contentPadding: EdgeInsets.zero,
    );
  }
}
