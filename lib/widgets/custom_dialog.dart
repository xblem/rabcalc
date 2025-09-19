// lib/widgets/custom_dialog.dart

import 'package:flutter/material.dart';

// Helper function untuk memanggil dialog dengan mudah
Future<void> showCustomStatusDialog({
  required BuildContext context,
  required bool isSuccess,
  required String title,
  required String message,
  required String buttonText,
  VoidCallback? onButtonPressed,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomStatusDialog(
        isSuccess: isSuccess,
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
      );
    },
  );
}

// Widget utama untuk dialog
class CustomStatusDialog extends StatelessWidget {
  final bool isSuccess;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const CustomStatusDialog({
    super.key,
    required this.isSuccess,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = isSuccess ? const Color(0xFF27AE60) : const Color(0xFFE53935);
    final String iconPath = isSuccess ? 'assets/images/icon_success.png' : 'assets/images/icon_error.png';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, height: 80),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}