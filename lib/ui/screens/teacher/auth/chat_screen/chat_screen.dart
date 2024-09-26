// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/ui/screens/teacher/auth/chat_screen/chat_view_model.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(),
      child: Consumer<ChatViewModel>(
        builder: (context, model, child) => const Scaffold(
          ///
          /// Start Body
          ///
          body: Center(
            child: Text("Chat Screen"),
          ),
        ),
      ),
    );
  }
}
