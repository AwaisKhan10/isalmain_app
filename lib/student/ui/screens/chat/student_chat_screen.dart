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

class StudentChatScreen extends StatelessWidget {
  const StudentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authServices = locator<AuthServices>();
    final databaseServices = locator<DatabaseServices>();
    final currentUserId = authServices.studentUser.id ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Text("Student Chat",
            style: styleB25.copyWith(color: secondaryColor)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<List<ConversationModel>>(
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
                    Icon(Icons.chat_outlined, size: 60.sp, color: Colors.grey),
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
                  final otherName = conversation.getOtherName(currentUserId);
                  final otherId = conversation.getOtherId(currentUserId);
                  final lastMessage = conversation.lastMessage ?? "";
                  final time = conversation.lastTime != null
                      ? DateFormat('hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              conversation.lastTime!))
                      : "";
                  final userImage = "$staticAssets/fiver-profile.jpeg";

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                          color:
                                              secondaryColor.withOpacity(0.65)),
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
                                style: styleN12.copyWith(color: greyColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
