import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';
import 'package:sheduling_app/student/ui/screens/chat/widgets/message_bubble.dart';

import 'package:sheduling_app/teacher/core/services/database_services.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/core/model/message.dart';
import 'package:sheduling_app/locator.dart';
import 'package:intl/intl.dart';

class ConversationScreen extends StatefulWidget {
  final String userName;
  final String userImage;
  final String receiverId;

  const ConversationScreen({
    super.key,
    required this.userName,
    required this.userImage,
    required this.receiverId,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final DatabaseServices _databaseServices = locator<DatabaseServices>();
  final AuthServices _authServices = locator<AuthServices>();

  late String chatId;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = _authServices.isTeacher 
        ? _authServices.teacherUser.id ?? "" 
        : _authServices.studentUser.id ?? "";
    chatId = DatabaseServices.getChatId(currentUserId, widget.receiverId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundImage: AssetImage(widget.userImage),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: styleB18.copyWith(color: Colors.white),
                ),
                Text(
                  "Online",
                  style: styleN12.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _databaseServices.getMessages(chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No messages yet. Say hi!",
                      style: styleN14.copyWith(color: Colors.grey),
                    ),
                  );
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUserId;
                    final time = DateFormat('hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(message.time ?? 0));
                    
                    return MessageBubble(
                      text: message.content ?? "",
                      isMe: isMe,
                      time: time,
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: MediaQuery.of(context).padding.bottom + 10.h,
        top: 10.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: TextField(
                controller: _messageController,
                style: styleN16,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: styleN14.copyWith(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: _sendMessage,
            child: CircleAvatar(
              radius: 22.r,
              backgroundColor: primaryColor,
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      final content = _messageController.text.trim();
      _messageController.clear();
      
      final senderName = _authServices.isTeacher 
          ? _authServices.teacherUser.fullName 
          : _authServices.studentUser.fullName;

      final message = MessageModel(
        senderId: currentUserId,
        receiverId: widget.receiverId,
        content: content,
        chatId: chatId,
        time: DateTime.now().millisecondsSinceEpoch,
      );
      
      await _databaseServices.sendMessage(
        message,
        senderName: senderName,
        receiverName: widget.userName,
      );
    }
  }
}
