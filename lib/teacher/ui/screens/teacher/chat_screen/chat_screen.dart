// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/strings.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/teacher/ui/screens/teacher/chat_screen/chat_view_model.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(),
      child: Consumer<ChatViewModel>(
        builder: (context, model, child) => Scaffold(
          ///
          /// App Bar
          ///
          appBar: _appBar(),

          ///
          /// Start Body
          ///
          body: ListView.builder(
              shrinkWrap: true,
              itemCount: 8,
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundImage: const AssetImage(
                                "$staticAssets/fiver-profile.jpeg"),
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Awais khan",
                                style: styleB18,
                              ),
                              Text(
                                "chating messages show",
                                style: styleN16.copyWith(
                                    color: secondaryColor.withOpacity(0.65)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "4:15",
                        style: styleN14.copyWith(color: blackColor),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}

AppBar _appBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Chats",
            style: styleB25.copyWith(color: secondaryColor, fontSize: 28.sp)),
      ],
    ),
  );
}
