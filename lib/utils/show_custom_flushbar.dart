import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showErrorFlushbar(BuildContext context, String message) {
  Flushbar(
    messageText: Text(
      message,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
    ),
    icon: const Icon(Icons.error_outline, size: 28.0, color: Colors.white),
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: const Color(0xFFEF665B), // Warna merah dari CSS
    borderRadius: BorderRadius.circular(8),
    margin: const EdgeInsets.all(8),
    duration: const Duration(seconds: 3),
    boxShadows: const [BoxShadow(color: Colors.black26, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  ).show(context);
}

void showSuccessFlushbar(BuildContext context, String message) {
  Flushbar(
    messageText: Text(
      message,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
    ),
    icon: const Icon(Icons.check_circle_outline, size: 28.0, color: Colors.white),
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: const Color(0xFF4CAF50), // Warna hijau untuk sukses
    borderRadius: BorderRadius.circular(8),
    margin: const EdgeInsets.all(8),
    duration: const Duration(seconds: 3),
    boxShadows: const [BoxShadow(color: Colors.black26, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  ).show(context);
}