// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/strings.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';

import 'package:sheduling_app/teacher/ui/screens/profile/components/edit_profile.dart';

import 'package:sheduling_app/teacher/ui/screens/profile/profile_view_model.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, model, child) => Scaffold(
          ///
          /// App Bar
          ///
          appBar: _appBar(model),

          ///
          /// Start Body
          ///
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 100.h,
                ),
                _detailContainer(
                    title: "Edit Profile Detail",
                    onPressed: () {
                      Get.to(() => EditProfile());
                    }),
                _detailContainer(
                    title: "Terms And Conditions", onPressed: () {}),
                _detailContainer(title: "About Us", onPressed: () {}),
                _detailContainer(
                    title: "Log Out",
                    onPressed: () {
                      model.logout();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

AppBar _appBar(ProfileViewModel model) {
  return AppBar(
    automaticallyImplyLeading: false,
    toolbarHeight: 280.h,
    backgroundColor: Colors.transparent,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text("Profile",
              style: styleB25.copyWith(color: secondaryColor, fontSize: 28.sp)),
        ),
        SizedBox(
          height: 20.h,
        ),
        CircleAvatar(
          radius: 80.r,
          backgroundImage: const AssetImage("$staticAssets/fiver-profile.jpeg"),
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          "${model.authServices.teacherUser.fullName}",
          style: styleB25,
        ),
        Text(
          "${model.authServices.teacherUser.email}",
          style: styleN14.copyWith(color: Colors.grey),
        ),
      ],
    ),
  );
}

_detailContainer({required String title, required VoidCallback onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: secondaryColor.withOpacity(0.25),
              offset: const Offset(0.0, 4.0),
              blurRadius: 4.0,
              spreadRadius: 2.0,
            ),
          ]),
      child: Text(
        "$title",
        style: styleB14,
      ),
    ),
  );
}
