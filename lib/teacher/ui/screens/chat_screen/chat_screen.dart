// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/strings.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';

import 'package:sheduling_app/student/ui/screens/chat/conversation_screen.dart';

import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/core/model/conversation.dart';
import 'package:sheduling_app/locator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseServices = locator<DatabaseServices>();

    return Scaffold(
      ///
      /// App Bar
      ///
      appBar: _appBar(),

      ///
      /// Start Body
      ///
      body: Consumer<AuthServices>(
        builder: (context, auth, child) {
          final currentUserId = auth.currentUserId;

          if (!auth.isInitialized || currentUserId.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<List<ConversationModel>>(
              stream: databaseServices.getConversations(currentUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_outlined,
                            size: 60.sp, color: Colors.grey),
                        SizedBox(height: 10.h),
                        const Text("No conversations yet."),
                      ],
                    ),
                  );
                }

                final conversations = snapshot.data!;

                return ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      final otherName =
                          conversation.getOtherName(currentUserId);
                      final otherId = conversation.getOtherId(currentUserId);
                      final lastMessage = conversation.lastMessage ?? "";
                      final time = conversation.lastTime != null
                          ? DateFormat('hh:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  conversation.lastTime!))
                          : "";
                      final userImage = "$iconAssets/student.png";

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConversationScreen(
                                userName: otherName,
                                userImage: userImage,
                                receiverId: otherId,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: secondaryColor)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 26.r,
                                      backgroundImage: AssetImage(userImage),
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          otherName,
                                          style: styleB18,
                                        ),
                                        SizedBox(
                                          width: 180.w,
                                          child: Text(
                                            lastMessage,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: styleN14.copyWith(
                                                color: secondaryColor
                                                    .withOpacity(0.65)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      time,
                                      style:
                                          styleN12.copyWith(color: greyColor),
                                    ),
                                    if (conversation
                                            .getUnreadCount(currentUserId) >
                                        0)
                                      Container(
                                        margin: EdgeInsets.only(top: 5.h),
                                        padding: EdgeInsets.all(6.r),
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${conversation.getUnreadCount(currentUserId)}",
                                          style: styleN12.copyWith(
                                              color: Colors.white,
                                              fontSize: 10.sp),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              });
        },
      ),
    );
  }
}

AppBar _appBar() {
  return AppBar(
    automaticallyImplyLeading: false,
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
