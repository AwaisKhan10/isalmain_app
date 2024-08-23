// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/core/constants/colors.dart';
import 'package:sheduling_app/custom_widgets/buttons/custom_button.dart';
import 'package:sheduling_app/custom_widgets/custom_onbording_screen.dart';
import 'package:sheduling_app/ui/screens/onbaording/onbaording_view_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
      create: (context) => OnboardingViewModel(),
      child: Consumer<OnboardingViewModel>(
        builder: (context, model, child) => Scaffold(
          ///
          /// Start Body
          ///
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///
              /// Header
              ///

              Expanded(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      pageSnapping: true,
                      controller: model.pageController,
                      itemCount: model.onboardings.length,
                      onPageChanged: model.onChanged,
                      itemBuilder: (context, index) {
                        return CustomOnBoarding(
                          onboarding: model.onboardings[index],
                        );
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(30.0),
                    //   child: Image.asset(
                    //     AppAssets.app_logo,
                    //     scale: 8,
                    //   ),
                    // ),
                  ],
                ),
              )

              ///
              /// PageView Builder
              ///
              /// Scrolling Images
              ///
              ,

              ///
              /// Indicator
              ///
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0, top: 50),
                child: AnimatedSmoothIndicator(
                  activeIndex: model.currentPage,
                  count: model.onboardings.length,
                  effect: WormEffect(
                    dotWidth: 12.w,
                    activeDotColor: primaryColor,
                    dotColor: lightBlueColor,
                  ),
                ),
              ),

              ///
              /// CustomButton
              ///
              CustomButton(
                onPressed: () {
                  model.animateToPage(context);
                  // Get.to(() => const SignUpScreen());
                },
                name: 'Next',
                textColor: whiteColor,
              ),

              ///
              /// Already Sign In
              ///
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 20.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Text(
              //         "Already a member?",
              //         style: kHeading3.copyWith(fontWeight: FontWeight.w400),
              //       ),
              //       TextButton(
              //         onPressed: () {
              //           Navigator.pushReplacement(context,
              //               NavigationFromRightRoute(page: SignInScreen()));
              //           // Get.to(() => const SignInScreen());
              //         },
              //         child: Text(
              //           "Sign In",
              //           style: kHeading3.copyWith(
              //               fontWeight: FontWeight.w500,
              //               color: KPrimaryColor),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
