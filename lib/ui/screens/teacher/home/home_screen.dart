// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/core/constants/colors.dart';
import 'package:sheduling_app/core/constants/strings.dart';
import 'package:sheduling_app/core/constants/text_style.dart';
import 'package:sheduling_app/ui/screens/teacher/auth/sign_up/sign_up_view_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(
      builder: (context, model, child) => Scaffold(
        ///
        /// App Bar
        ///
        appBar: _appBar(),

        ///
        /// Start Body
        ///
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "Departments",
                textAlign: TextAlign.center,
                style:
                    styleB25.copyWith(color: secondaryColor, fontSize: 30.sp),
              ),
              const SizedBox(
                height: 15,
              ),
              GridView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0),
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [primaryColor, secondaryColor]),
                          boxShadow: [
                            BoxShadow(
                                color: secondaryColor.withOpacity(0.20),
                                offset: const Offset(0, 4),
                                spreadRadius: 4,
                                blurRadius: 4)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: Text(
                              "Statistics",
                              style: styleB25.copyWith(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            "Subject: Calculas",
                            textAlign: TextAlign.center,
                            style: styleB16.copyWith(color: whiteColor),
                          ),
                          Text(
                            "Semester: 4th",
                            textAlign: TextAlign.center,
                            style: styleB16.copyWith(color: whiteColor),
                          ),
                          Text(
                            "Time: 10:30 to 11:30",
                            textAlign: TextAlign.center,
                            style: styleB14.copyWith(color: whiteColor),
                          ),
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),

        ///
        /// Floating Action Button
        ///
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondaryColor,
          // focusColor: blackColor,
          // hoverColor: blackColor,
          // splashColor: blackColor,
          // foregroundColor: blackColor,
          onPressed: () {
            // Navigate to Sign In Screen
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => SignInScreen(),
            //   ),
            // );
          },
          child: Icon(
            Icons.person_add,
            color: whiteColor,
          ),
        ),
      ),
    );
  }
}

AppBar _appBar() {
  return AppBar(
    elevation: 0.0,
    // shadowColor: secondaryColor,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    toolbarHeight: 80.h,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Awais khan",
            style: styleB25.copyWith(color: secondaryColor, fontSize: 28.sp)),
        Text(
          "Software Engineer",
          style: styleB16,
        ),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: CircleAvatar(
          radius: 30.r,
          backgroundImage: const AssetImage("$staticAssets/fiver-profile.jpeg"),
        ),
      ),
      // CircleAvatar(
      //   radius: 25.r,
      //   backgroundColor: secondaryColor,
      //   child: IconButton(
      //     icon: Icon(
      //       Icons.notifications,
      //       size: 35.sp,
      //       color: whiteColor,
      //     ),
      //     onPressed: () {},
      //   ),
      // ),
    ],
  );
}
