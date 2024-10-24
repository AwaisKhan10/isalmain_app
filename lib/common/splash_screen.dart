// ignore_for_file: avoid_print, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheduling_app/common/welcome_screen.dart';
import 'package:sheduling_app/teacher/core/constants/app_assets.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';

import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/common/onbaording/onbaording_screen.dart';
import 'package:sheduling_app/teacher/ui/screens/root/root_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final _authService = locator<AuthServices>();
  final _auth = locator<AuthServices>();
  bool _isloading = true;

  @override
  void initState() {
    _initialSetup();

    super.initState();
  }

  _initialSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboarding = prefs.getBool("seenOnboarding") ?? false;

    if (!seenOnboarding) {
      Get.off(() => WelcomeScreen());
      setState(() {
        _isloading = false;
      });
      return;
    }

    await _auth.init();

    await Future.delayed(const Duration(seconds: 3));
    if (_auth.isLogin!) {
      Get.off(() => RootScreen());
    } else {
      Get.off(() => OnBoardingScreen());
    }
    setState(() {
      _isloading = false;
    });
    //function for one time onboarding screen sharedPreferences
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
