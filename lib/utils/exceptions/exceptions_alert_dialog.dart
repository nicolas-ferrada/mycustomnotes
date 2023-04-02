import 'package:flutter/material.dart';

class ExceptionsAlertDialog {
  //Error dialog message function
  static Future<void> showErrorDialog(
    BuildContext context,
    String errorMessage,
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.redAccent[200],
          title: const Center(
            child: Text('Error'),
          ),
          content: SizedBox(
            height: 50,
            child: Center(
              child: Text(
                errorMessage.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Navigator.maybePop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
