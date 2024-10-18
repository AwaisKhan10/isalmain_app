// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/strings.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/ui/screens/profile/profile_view_model.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfileViewModel(),
        child: Consumer<ProfileViewModel>(
          builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                "Edit Profile",
                style: styleB25.copyWith(color: secondaryColor, fontSize: 28),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Positioned(
                          child: CircleAvatar(
                              radius: 80.r,
                              backgroundImage: const AssetImage(
                                  "$staticAssets/fiver-profile.jpeg")),
                        ),
                        edit_image()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: Text("Asad Qureshi"),
                    trailing: edit_image(),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Container edit_image() {
    return Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12)),
        child: Image.asset("$iconAssets/edit_icon.png"));
  }
}
