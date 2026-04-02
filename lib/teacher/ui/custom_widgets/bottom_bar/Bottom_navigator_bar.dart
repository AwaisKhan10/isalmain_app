// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:ustad/core/others/screen_utils.dart';

class CustomBottomNavigator extends StatelessWidget {
  final image;
  final String label;
  final currentIndex;
  final indexNumber;
  final iconColor;
  VoidCallback? onPressed;

  CustomBottomNavigator({
    super.key,
    required this.image,
    required this.label,
    required this.currentIndex,
    required this.indexNumber,
    required this.iconColor,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "$image",
              height: 24.h,
              width: 24.w,
              color: iconColor,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontSize: 10.sp,
                fontWeight: currentIndex == indexNumber
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ));
  }
}
