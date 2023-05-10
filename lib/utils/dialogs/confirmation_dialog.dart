import 'package:flutter/material.dart';
import '../../l10n/l10n_export.dart';
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
          title: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.grey.shade800.withOpacity(0.9),
              child: Text(
                textAlign: TextAlign.center,
                AppLocalizations.of(context)!.logOutTitle_drawerDialog_homePage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          content: Text(
            textAlign: TextAlign.center,
            AppLocalizations.of(context)!.logOutInfo_drawerDialog_homePage,
            style: const TextStyle(color: Colors.white, fontSize: 18),
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
                            context: context,
                            errorMessage: errorMessage.toString());
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .logOut_button_drawerDialog_homePage,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.cancelButton,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
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
