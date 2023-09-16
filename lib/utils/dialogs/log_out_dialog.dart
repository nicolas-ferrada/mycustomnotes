import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import '../../domain/services/auth_services.dart/auth_user_service.dart';
import '../../l10n/l10n_export.dart';
import '../exceptions/exceptions_alert_dialog.dart';
import '../styles/dialog_subtitle_style.dart';
import '../styles/dialog_title_style.dart';

class LogOutDialog {
  // Log out from firebase confirmation
  static Future<dynamic> logOutDialog(BuildContext context, User currentUser) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.grey.shade400,
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
                        await AuthUserService.logOut(
                          context: context,
                        ).then((value) => Navigator.maybePop(context));
                      } catch (errorMessage) {
                        if (!context.mounted) return;

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
}
