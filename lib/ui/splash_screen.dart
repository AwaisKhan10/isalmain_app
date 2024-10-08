// ignore_for_file: avoid_print, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:sheduling_app/core/constants/app_assets.dart';
import 'package:sheduling_app/core/constants/colors.dart';
import 'package:sheduling_app/ui/screens/onbaording/onbaording_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final _authService = locator<AuthServices>();

  @override
  void initState() {
    _initialSetup();
    super.initState();
  }

  _initialSetup() async {
    await Future.delayed(const Duration(seconds: 1));
    Get.offAll(() => OnBoardingScreen());
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: whiteColor,
          height: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.app_logo,
                    scale: 2,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
