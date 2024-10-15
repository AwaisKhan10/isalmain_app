import 'package:flutter/material.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';

final authFieldDecoration = InputDecoration(
  hintText: "Enter your email",
  hintStyle: styleB14.copyWith(color: Colors.grey),
  prefixIconColor: whiteColor,
  suffixIconColor: whiteColor,
  fillColor: whiteColor,
  filled: true,
  border: InputBorder.none,
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: blackColor, width: 0.0),
      borderRadius: BorderRadius.circular(16)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: blackColor, width: 0.0),
      borderRadius: BorderRadius.circular(16)),
  errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: blackColor, width: 0.0),
      borderRadius: BorderRadius.circular(16)),
  disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: blackColor, width: 0.0),
      borderRadius: BorderRadius.circular(16)),
  focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: blackColor, width: 0.0),
      borderRadius: BorderRadius.circular(16)),
);

class KWhiteColor {}
