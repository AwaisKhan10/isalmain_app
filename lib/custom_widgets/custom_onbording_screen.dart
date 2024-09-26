import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheduling_app/core/constants/colors.dart';
import 'package:sheduling_app/core/constants/text_style.dart';
import 'package:sheduling_app/core/model/onbaording.dart';

class CustomOnBoarding extends StatelessWidget {
  Onboarding onboarding;

  CustomOnBoarding({required this.onboarding});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        height: 100.h,
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
        style: styleB18.copyWith(color: primaryColor),
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
}
