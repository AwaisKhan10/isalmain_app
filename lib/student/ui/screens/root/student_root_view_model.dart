import 'package:flutter/material.dart';
import 'package:sheduling_app/teacher/core/enums/view_state.dart';
import 'package:sheduling_app/teacher/core/view_model/view_model.dart';
import 'package:sheduling_app/student/home_screen.dart';
import 'package:sheduling_app/student/ui/screens/chat/student_chat_screen.dart';
import 'package:sheduling_app/student/ui/screens/profile/student_profile_screen.dart';

class StudentRootViewModel extends BaseViewModel {
  final PageController pageController = PageController(initialPage: 0);

  StudentRootViewModel(val) {
    updatedScreen(val);
  }

  int selectedScreen = 0;

  List<Widget> allScreen = [
    const StudentHomeScreen(),
    const StudentChatScreen(),
    const StudentProfileScreen(),
  ];

  updatedScreen(int index) {
    setState(ViewState.busy);
    selectedScreen = index;
    setState(ViewState.idle);
    notifyListeners();
  }
}
