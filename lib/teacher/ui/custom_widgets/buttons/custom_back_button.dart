// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';

class CustomBackButton extends StatefulWidget {
  VoidCallback? onPressed;
  CustomBackButton({this.onPressed});

  @override
  _CustomBackButtonState createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed?.call();
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
          height: 30.h,
          width: 30.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient:
                const LinearGradient(colors: [primaryColor, secondaryColor]),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 22.sp,
            color: whiteColor,
          ),
        ),
      ),
    );
  }
}
