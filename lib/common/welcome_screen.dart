// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sheduling_app/student/home_screen.dart';
import 'package:sheduling_app/teacher/core/constants/app_assets.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';

import 'package:sheduling_app/teacher/ui/screens/auth/sign_up/sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.background_image,
                scale: 4,
              ),
              SizedBox(
                height: 90.h,
              ),
              Text(
                "YOU ARE TEACHER OR STUDENT",
                style: styleB18.copyWith(color: secondaryColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.h,
              ),
              _PressableButton(
                  image: AppAssets.teacher,
                  text: "Teacher",
                  onPressed: () {
                    Get.to(() => TeacherSignUpScreen());
                  }),
              SizedBox(
                height: 20.h,
              ),
              _PressableButton(
                  image: AppAssets.student,
                  text: "Student",
                  onPressed: () {
                    Get.to(() => const StudentHomeScreen());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class _PressableButton extends StatefulWidget {
  final String image;
  final String text;
  final VoidCallback onPressed;

  const _PressableButton({
    required this.image,
    required this.text,
    required this.onPressed,
  });

  @override
  _PressableButtonState createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          alignment: Alignment.center,
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                  color: blackColor.withOpacity(0.20),
                  offset: const Offset(0, 2.0),
                  blurRadius: 2.0,
                  spreadRadius: 1),
            ],
            gradient:
                const LinearGradient(colors: [primaryColor, secondaryColor]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                widget.image,
                scale: 2,
              ),
              SizedBox(
                width: 30.w,
              ),
              Text(
                widget.text,
                style: styleB25.copyWith(color: whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
