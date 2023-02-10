import 'package:flutter/material.dart';

class SnackBarMessage {
  static SnackBar snackBarMessage({
    required String message,
    required Color backgroundColor,
  }) {
    final snackBarMessage = SnackBar(
      duration: const Duration(seconds: 1),
      content: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: backgroundColor,
    );
    return snackBarMessage;
  }
}
