import 'package:flutter/cupertino.dart';
import 'package:sheduling_app/teacher/core/constants/app_assets.dart';
import 'package:sheduling_app/teacher/core/model/onbaording.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/custom_routes/navigate_from_right.dart';
import 'package:sheduling_app/common/welcome_screen.dart';

class OnboardingViewModel extends BaseViewModel {
  final PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;

  ///
  /// chnage the value
  ///

  onChanged(int value) {
    currentPage = value;

    notifyListeners();
  }

  ///
  ///  List onboardings
  ///
  List<Onboarding> onboardings = [
    Onboarding(
        image: AppAssets.onBoarding3,
        title: 'Welcome to Islamia!',
        description:
            'Seamless communication and scheduling between teachers and students—your gateway to an organized learning experience.'),
    Onboarding(
        image: AppAssets.onBoarding2,
        title: 'Manage Your Schedule',
        description:
            'View your timetable, class locations, and course details all in one place. Stay on top of your academic life with ease.'),
  ];

  animateToPage(BuildContext context) {
    int index = currentPage + 1;
    if (index < onboardings.length) {
      pageController.animateToPage(
        index,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 300),
      );
    } else {
      Navigator.pushReplacement(
          context, NavigationFromRightRoute(page: WelcomeScreen()));
    }
    notifyListeners();
  }
}
