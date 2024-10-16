import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheduling_app/common/welcome_screen.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/core/model/onbaording.dart';

// ignore: must_be_immutable
class CustomOnBoarding extends StatelessWidget {
  Onboarding onboarding;

  CustomOnBoarding({super.key, required this.onboarding});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(
        height: 50,
      ),
      skipButton(),
      SizedBox(
        height: 50.h,
      ),
      Container(
        height: 400.h,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("${onboarding.image}"), fit: BoxFit.cover)),
      ),
      // Expanded(
      //     child: Image.asset(
      //   "${onboarding.image}",
      //   height: 400,
      // )),
      // SizedBox(
      //   height: 30.h,
      // ),

      ///
      /// Header
      ///
      Text(
        "${onboarding.title}",
        style: styleB18.copyWith(
          color: primaryColor,
        ),
      ),
      SizedBox(
        height: 5.h,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Text("${onboarding.description}",
            textAlign: TextAlign.center,
            style: styleB14.copyWith(color: lightBlueColor)),
      ),
    ]);
  }

  Row skipButton() {
    return Row(
      children: [
        const Spacer(),
        TextButton(
            onPressed: () async {
              final pref = await SharedPreferences.getInstance();

              pref.setBool("seenOnboarding", true);

              Get.offAll(() => WelcomeScreen());
            },
            child: const Text(
              "Skip",
              style: TextStyle(color: primaryColor, fontSize: 18),
            )),
      ],
    );
  }
}
