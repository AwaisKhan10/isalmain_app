import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/ui/screens/teacher/auth/sign_in/sign_in_view_model.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SignInViewModel(),
        child: Consumer<SignInViewModel>(
          builder: (context, value, child) => Scaffold(),
        ));
  }
}
