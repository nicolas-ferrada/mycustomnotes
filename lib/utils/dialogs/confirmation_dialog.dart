import 'package:flutter/material.dart';
import '../exceptions/exceptions_alert_dialog.dart';
import '../../domain/services/auth_user_service.dart';

class ConfirmationDialog {
  // Log out from firebase confirmation
  static Future<dynamic> logOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: const Color.fromRGBO(250, 216, 90, 0.8),
          title: const Center(
            child: Text('Log out'),
          ),
          content: const Text(
            'Do you really want to log out?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () async {
                      // log out firebase
                      try {
                        await AuthUserService.logOutUserFirebase(
                                context: context)
                            .then((value) => Navigator.maybePop(context));
                      } catch (errorMessage) {
                        ExceptionsAlertDialog.showErrorDialog(
                            context, errorMessage.toString());
                      }
                    },
                    child: const Text(
                      'Log out',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Discard changes from note's details confirmation
  static Future<dynamic> discardChangesNoteDetails(BuildContext context) {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: const Color.fromARGB(204, 250, 212, 78),
          title: const Center(
            child: Text('Discard changes?'),
          ),
          content: const Text(
            'Are you sure you want to discard all the changes?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () async {
                      Navigator.maybePop(context, true);
                    },
                    child: const Text(
                      'Discard changes',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.maybePop(context, false);
                    },
                    child: const Text(
                      'Cancel and stay here',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
