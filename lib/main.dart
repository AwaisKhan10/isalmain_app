import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/core/constants/colors.dart';
import 'package:sheduling_app/ui/screens/teacher/auth/sign_up/sign_up_view_model.dart';
import 'package:sheduling_app/ui/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(
          MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SignUpViewModel()),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Islamian App',
          theme: ThemeData(
            scaffoldBackgroundColor: whiteColor,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
