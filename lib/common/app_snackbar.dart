import 'package:flutter/material.dart';
import 'package:sheduling_app/common/app_messenger.dart';
import 'package:sheduling_app/teacher/core/constants/colors.dart';

enum SnackBarType { success, error, info }

class AppSnackbar {
  static void show(
    String title,
    String message, {
    SnackBarType type = SnackBarType.info,
  }) {
    final Color backgroundColor;
    final IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = const Color(0xFF2E7D32);
        icon = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        backgroundColor = const Color(0xFFC62828);
        icon = Icons.error_outline;
        break;
      case SnackBarType.info:
        backgroundColor = secondaryColor;
        icon = Icons.info_outline;
        break;
    }

    final messenger = AppMessenger.scaffoldMessengerKey.currentState;
    if (messenger == null) {
      debugPrint('AppSnackbar [$title]: $message');
      return;
    }

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: whiteColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: const TextStyle(color: whiteColor, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void success(String message, {String title = 'Success'}) =>
      show(title, message, type: SnackBarType.success);

  static void error(String message, {String title = 'Error'}) =>
      show(title, message, type: SnackBarType.error);

  static void info(String message, {String title = 'Info'}) =>
      show(title, message, type: SnackBarType.info);
}
