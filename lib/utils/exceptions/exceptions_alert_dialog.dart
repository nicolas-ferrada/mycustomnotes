import 'package:flutter/material.dart';
import '../../l10n/l10n_export.dart';

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
          title: Center(
            child: Text(AppLocalizations.of(context)!.errorTitle),
          ),
          content: SingleChildScrollView(
            child: Text(
              errorMessage.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
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
