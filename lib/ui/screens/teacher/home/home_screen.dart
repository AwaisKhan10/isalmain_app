// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/ui/screens/teacher/auth/sign_up/sign_up_view_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(
      builder: (context, model, child) => const Scaffold(
        ///
        /// Start Body
        ///
        body: Center(
          child: Text("Home Screen"),
        ),
      ),
    );
  }
}
