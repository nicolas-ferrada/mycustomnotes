import 'package:flutter/material.dart';
import '../../l10n/l10n_export.dart';
import '../exceptions/exceptions_alert_dialog.dart';
import '../../domain/services/auth_user_service.dart';
import '../styles/dialog_subtitle_style.dart';
import '../styles/dialog_title_style.dart';

class ConfirmationDialog {
  // Log out from firebase confirmation
  static Future<dynamic> logOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: const Color.fromRGBO(250, 216, 90, 0.8),
          title: DialogTitleStyle(
            title:
                AppLocalizations.of(context)!.logOutTitle_drawerDialog_homePage,
          ),
          content: DialogSubtitleStyle(
            subtitle:
                AppLocalizations.of(context)!.logOutInfo_drawerDialog_homePage,
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.white,
                    ),
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
                  const SizedBox(
                    height: 4,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.cancelButton,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
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
          title: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade800.withOpacity(0.8),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                textAlign: TextAlign.center,
                AppLocalizations.of(context)!.discardChanges_dialog_title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          content: DialogSubtitleStyle(
              subtitle:
                  AppLocalizations.of(context)!.discardChanges_dialog_subtitle),
          actions: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 50),
                      elevation: 5,
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      Navigator.maybePop(context, true);
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .discardChanges_dialog_leaveButton,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 50),
                      elevation: 5,
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.maybePop(context, false);
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .discardChanges_dialog_cancelButton,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
