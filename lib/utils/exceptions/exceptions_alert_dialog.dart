import 'package:flutter/material.dart';
import 'package:mycustomnotes/l10n/l10n_export.dart';

class ExceptionsAlertDialog {
  //Error dialog message function
  static Future<void> showErrorDialog({
    required BuildContext context,
    required String errorMessage,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.redAccent[200],
          title: const Center(
            child: Text('Error'),
          ),
          content: Text(
            errorMessage.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Navigator.maybePop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.closeButton,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
