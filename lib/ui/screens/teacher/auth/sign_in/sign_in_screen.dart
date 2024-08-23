import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/core/constants/app_assets.dart';
import 'package:sheduling_app/core/constants/auth_field_decoration.dart';
import 'package:sheduling_app/core/constants/colors.dart';
import 'package:sheduling_app/core/constants/text_style.dart';
import 'package:sheduling_app/custom_widgets/buttons/custom_back_button.dart';
import 'package:sheduling_app/custom_widgets/buttons/custom_button.dart';
import 'package:sheduling_app/custom_widgets/custom_routes/navigate_from_right.dart';
import 'package:sheduling_app/ui/screens/teacher/auth/sign_in/sign_in_view_model.dart';
import 'package:sheduling_app/ui/screens/teacher/auth/sign_up/sign_up_screen.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SignInViewModel(),
        child: Consumer<SignInViewModel>(
          builder: (context, model, child) => Scaffold(
            ///
            /// Start Body
            ///
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomBackButton(
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          "Sign In",
                          style: styleB25.copyWith(
                              color: blackColor, fontSize: 30.sp),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "Please enter the email address and password to sign",
                      style: styleN16.copyWith(color: blackColor),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    TextFormField(
                      decoration:
                          authFieldDecoration.copyWith(hintText: 'Full Name'),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      decoration: authFieldDecoration.copyWith(
                          hintText: 'Email address'),
                    ),

                    SizedBox(
                      height: 20.h,
                    ),
                    TextFormField(
                      decoration:
                          authFieldDecoration.copyWith(hintText: 'Password'),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomButton(
                        name: 'SignUp',
                        onPressed: () {},
                        textColor: lightPinkColor),

                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            AppAssets.dividerImageLeft,
                            color: primaryColor,
                            scale: 2.9,
                          ),
                          Text(
                            "OR",
                            style: styleB14.copyWith(fontSize: 12),
                          ),
                          Image.asset(AppAssets.dividerImageRight,
                              color: primaryColor, scale: 2.9),
                        ],
                      ),
                    ),

                    ///
                    /// Sign In Google User
                    ///
                    Container(
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: secondaryColor),
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.googleLogo,
                            scale: 3,
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Text(
                            "Sign In Using Google",
                            style: styleB16.copyWith(color: blackColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "New Here?",
                          style: styleB14.copyWith(fontWeight: FontWeight.w400),
                        ),
                        TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pushReplacement(context,
                                NavigationFromRightRoute(page: SignUpScreen()));
                          },
                          child: Text(
                            "Sign Up",
                            style: styleB16.copyWith(
                              color: secondaryColor,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
