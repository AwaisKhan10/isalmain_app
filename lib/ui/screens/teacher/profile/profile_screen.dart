// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/ui/screens/teacher/profile/profile_view_model.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, model, child) => const Scaffold(
          ///
          /// Start Body
          ///
          body: Center(
            child: Text("Profile Screen"),
          ),
        ),
      ),
    );
  }
}
