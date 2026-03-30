import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/app_assets.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/ui/custom_widgets/bottom_bar/Bottom_navigator_bar.dart';
import 'package:sheduling_app/student/ui/screens/root/student_root_view_model.dart';

class StudentRootScreen extends StatelessWidget {
  final int? selectedScreen;
  const StudentRootScreen({super.key, this.selectedScreen = 0});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StudentRootViewModel(selectedScreen),
      child: Consumer<StudentRootViewModel>(
        builder: (context, model, child) => Scaffold(
          body: model.allScreen[model.selectedScreen],
          bottomNavigationBar: _bottomBar(model),
        ),
      ),
    );
  }

  Widget _bottomBar(StudentRootViewModel model) {
    return BottomAppBar(
      color: whiteColor,
      elevation: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomBottomNavigator(
            currentIndex: model.selectedScreen,
            indexNumber: 0,
            iconColor: model.selectedScreen == 0 ? secondaryColor : blackColor,
            image: model.selectedScreen == 0
                ? AppAssets.homeIconImage1
                : AppAssets.homeIconImage2,
            onPressed: () => model.updatedScreen(0),
          ),
          CustomBottomNavigator(
            currentIndex: model.selectedScreen,
            iconColor: model.selectedScreen == 1 ? secondaryColor : blackColor,
            indexNumber: 1,
            image: AppAssets.chat,
            onPressed: () => model.updatedScreen(1),
          ),
          CustomBottomNavigator(
            currentIndex: model.selectedScreen,
            iconColor: model.selectedScreen == 2 ? secondaryColor : blackColor,
            indexNumber: 2,
            image: model.selectedScreen == 2
                ? AppAssets.profileIconImage1
                : AppAssets.profileIconImage2,
            onPressed: () => model.updatedScreen(2),
          ),
        ],
      ),
    );
  }
}
