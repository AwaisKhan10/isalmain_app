// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheduling_app/common/onbaording/onbaording_screen.dart';
import 'package:sheduling_app/common/splash_screen.dart';
import 'package:sheduling_app/common/welcome_screen.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/firebase_options.dart';
import 'package:sheduling_app/locator.dart';

import 'package:sheduling_app/teacher/ui/screens/auth/sign_up/sign_up_view_model.dart';

void main() async {
  // final pref = await SharedPreferences.getInstance();
  // final onboading = pref.getBool("onBoarding") ?? false;
  WidgetsFlutterBinding.ensureInitialized();

  // Stripe.publishableKey =
  //     'pk_test_51NETQVLRDc0a3gYh5RM29lcqFtg7Gu5V6hrRFlABsJP6vfWlR6vDMzL7mPVzDOHhYaIsAjan77Gad7Ra1zPD6UJa00hhu2m81p';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({super.key, this.onboarding = false});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(
          MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TeacherSignUpViewModel()),
        ],
        child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Islamian App',
            theme: ThemeData(
              fontFamily: "Cera Pro",
              scaffoldBackgroundColor: whiteColor,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: SplashScreen()),
      ),
    );
  }
}
