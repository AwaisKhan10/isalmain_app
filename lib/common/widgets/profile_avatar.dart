import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final File? localImage;
  final double radius;
  final VoidCallback? onTap;
  final bool showCameraBadge;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.localImage,
    required this.radius,
    this.onTap,
    this.showCameraBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (localImage != null) {
      imageProvider = FileImage(localImage!);
    } else if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      imageProvider = NetworkImage(imageUrl!);
    }

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: secondaryColor.withValues(alpha: 0.1),
      backgroundImage: imageProvider,
      child: imageProvider == null
          ? Icon(Icons.person, size: radius, color: secondaryColor)
          : null,
    );

    if (!showCameraBadge || onTap == null) {
      return GestureDetector(onTap: onTap, child: avatar);
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          avatar,
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: secondaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.camera_alt, color: whiteColor, size: 20),
          ),
        ],
      ),
    );
  }
}
