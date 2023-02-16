import 'package:flutter/material.dart';

class SnackBarMessage {
  static SnackBar snackBarMessage({
    required String message,
    Color? backgroundColor,
  }) {
    final snackBarMessage = SnackBar(
      duration: const Duration(milliseconds: 1500), // 1,5 secs
      content: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.grey,
    );
    return snackBarMessage;
  }
}
