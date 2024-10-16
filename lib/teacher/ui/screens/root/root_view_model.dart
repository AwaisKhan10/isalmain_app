import 'package:flutter/material.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';
import 'package:sheduling_app/teacher/ui/screens/chat_screen/chat_screen.dart';
import 'package:sheduling_app/teacher/ui/screens/profile/profile_screen.dart';
import '../home/home_screen.dart';

class RootViewModel extends BaseViewModel {
  final PageController pageController = PageController(initialPage: 0);
  RootViewModel(val) {
    updatedScreen(val);
    notifyListeners();
  }
  int selectedScreen = 0;
  // int selectIndex = 0;

  List<Widget> allScreen = [
    HomeScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  updatedScreen(int index) {
    setState(ViewState.busy);
    selectedScreen = index;
    setState(ViewState.idle);
    // selectIndex = index;
    notifyListeners();
  }

  // pushScreen(int index) {
  //   pageController.animateToPage(index,
  //       duration: Duration(milliseconds: 2000), curve: Curves.bounceIn);
  //   selectedScreen = index;
  //   notifyListeners();
  // }
}
