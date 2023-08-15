import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

import '../../../domain/services/auth_user_service.dart';
import '../../../l10n/l10n_export.dart';
import '../../../utils/dialogs/successful_mail_sent_recover_pasword_dialog.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';

class ChangePasswordPage extends StatefulWidget {
  final User currentUser;
  const ChangePasswordPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!
              .changePasswordTitle_text_myAccountWidgetChangePasswordPage,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .changePasswordSubtitle_text_myAccountWidgetChangePasswordPage,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              AppLocalizations.of(context)!
                  .changePasswordSubtitle2_text_myAccountWidgetChangePasswordPage,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                minimumSize: const Size(200, 60),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                resetPassword();
              },
              child: Text(
                AppLocalizations.of(context)!
                    .changePasswordTitle_text_myAccountWidgetChangePasswordPage,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword() async {
    try {
      if (widget.currentUser.email != null) {
        await AuthUserService.recoverPasswordUserFirebase(
          email: widget.currentUser.email!,
          context: context,
        ).then(
          (_) => Navigator.maybePop(context).then(
            (_) => showDialog(
              context: context,
              builder: (context) => SuccessfulMailSentRecoverPasswordDialog(
                  sucessMessage: AppLocalizations.of(context)!
                      .sucessfulMailSent_body_dialog_recoverPasswordPage),
            ),
          ),
        );
      } else {
        throw Exception(
            AppLocalizations.of(context)!.unexpectedException_dialog);
      }
    } catch (errorMessage) {
      ExceptionsAlertDialog.showErrorDialog(
        context: context,
        errorMessage: errorMessage.toString(),
      );
    }
  }
}
