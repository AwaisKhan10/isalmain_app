import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheduling_app/teacher/core/constants/app_assets.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/bottom_bar/Bottom_navigator_bar.dart';
import 'package:sheduling_app/teacher/ui/screens/root/root_view_model.dart';

class RootScreen extends StatelessWidget {
  final int? selectedScreen;
  const RootScreen({super.key, this.selectedScreen = 0});
  @override
  Widget build(BuildContext context) {
    return Consumer<RootViewModel>(
      builder: (context, model, child) => Scaffold(
        ///
        /// Start Body
        ///
        body: model.allScreen[model.selectedScreen],

        ///
        /// BottomBar
        ///
        bottomNavigationBar: bottomBar(model),
      ),
    );
  }
}

bottomBar(RootViewModel model) {
  return BottomAppBar(
    color: secondaryColor.withOpacity(0.4),
    shadowColor: blackColor,
    elevation: 6.0,
    height: 80.h,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomBottomNavigator(
          currentIndex: model.selectedScreen,
          indexNumber: 0,
          label: "Home",
          iconColor: model.selectedScreen == 0 ? primaryColor : blackColor,
          image: model.selectedScreen == 0
              ? AppAssets.homeIconImage1
              : AppAssets.homeIconImage2,
          onPressed: () {
            model.updatedScreen(0);
          },
        ),
        CustomBottomNavigator(
          currentIndex: model.selectedScreen,
          indexNumber: 1,
          label: "Chat",
          iconColor: model.selectedScreen == 1 ? primaryColor : blackColor,
          image: model.selectedScreen == 1 ? AppAssets.chat : AppAssets.chat,
          onPressed: () {
            model.updatedScreen(1);
          },
        ),
        CustomBottomNavigator(
          currentIndex: model.selectedScreen,
          indexNumber: 2,
          label: "Profile",
          iconColor: model.selectedScreen == 2 ? primaryColor : blackColor,
          image: model.selectedScreen == 2
              ? AppAssets.profileIconImage1
              : AppAssets.profileIconImage2,
          onPressed: () {
            model.updatedScreen(2);
          },
        ),
        // CustomBottomNavigator(
        //   currentIndex: model.selectedScreen,
        //   indexNumber: 1,
        //   image: model.selectedScreen == 1
        //       ? AppAssets.exploreIconImage1
        //       : AppAssets.exploreIconImage2,
        //   onPressed: () {
        //     model.updatedScreen(1);
        //   },
        // ),
        // CustomBottomNavigator(
        //   currentIndex: model.selectedScreen,
        //   indexNumber: 2,
        //   image: model.selectedScreen == 2
        //       ? AppAssets.profileIconImage1
        //       : AppAssets.profileIconImage2,
        //   onPressed: () {
        //     model.updatedScreen(2);
        //   },
        // ),
      ],
    ),
  );
}
