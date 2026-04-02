import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:sheduling_app/teacher/core/constants/text_style.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isMe ? secondaryColor : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r),
                bottomLeft:
                    isMe ? Radius.circular(15.r) : const Radius.circular(0),
                bottomRight:
                    isMe ? const Radius.circular(0) : Radius.circular(15.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.r,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Text(
              text,
              style: styleN16.copyWith(
                color: isMe ? whiteColor : blackColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            time,
            style: styleN12.copyWith(color: greyColor),
          ),
        ],
      ),
    );
  }
}
