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
import 'package:sheduling_app/student/ui/screens/chat/student_chat_screen.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/firebase_options.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/student/ui/screens/root/student_root_screen.dart';

import 'package:sheduling_app/teacher/ui/screens/auth/sign_up/sign_up_view_model.dart';
import 'package:sheduling_app/teacher/ui/screens/chat_screen/chat_screen.dart';
import 'package:sheduling_app/teacher/ui/screens/profile/profile_view_model.dart';
import 'package:sheduling_app/student/auth/signup/student_signup_view_model.dart';
import 'package:sheduling_app/student/auth/login/student_login_view_model.dart';
import 'package:sheduling_app/student/ui/screens/home/student_home_view_model.dart';
import 'package:sheduling_app/student/ui/screens/root/student_root_view_model.dart';
import 'package:sheduling_app/teacher/ui/screens/home/home_view_model.dart';
import 'package:sheduling_app/teacher/ui/screens/root/root_view_model.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';

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
          ChangeNotifierProvider(create: (context) => ProfileViewModel()),
          ChangeNotifierProvider(create: (context) => StudentSignUpViewModel()),
          ChangeNotifierProvider(create: (context) => StudentSignInViewModel()),
          ChangeNotifierProvider(create: (context) => StudentHomeViewModel()),
          ChangeNotifierProvider(create: (context) => StudentRootViewModel(0)),
          ChangeNotifierProvider(create: (context) => HomeViewModel()),
          ChangeNotifierProvider(create: (context) => RootViewModel(0)),
          ChangeNotifierProvider.value(value: locator<AuthServices>()),
        ],
        child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Islamian App',
            theme: ThemeData(
              fontFamily: "Cera Pro",
              appBarTheme: const AppBarTheme(
                elevation: 0,
              ),
              scaffoldBackgroundColor: whiteColor,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: SplashScreen()),
      ),
    );
  }
}
