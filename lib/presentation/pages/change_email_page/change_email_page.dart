import 'package:firebase_auth/firebase_auth.dart' show User, UserCredential;
import 'package:flutter/material.dart';
import 'package:mycustomnotes/domain/services/auth_user_service.dart';
import 'package:mycustomnotes/l10n/l10n_export.dart';

import '../../../utils/dialogs/successful_mail_sent_recover_pasword_dialog.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';

class ChangeEmailPage extends StatefulWidget {
  final User currentUser;
  const ChangeEmailPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _passwordLoginController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _confirmNewEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!
            .changeEmailTitle_text_myAccountWidgetChangeEmailPage),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .changeEmailSubtitle_text_myAccountWidgetChangeEmailPage,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  AppLocalizations.of(context)!
                      .changeEmailSubtitle2_text_myAccountWidgetChangeEmailPage,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              // Password input
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: _passwordLoginController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .changeEmailCurrentPasswordInput_textformfield_myAccountWidgetChangeEmailPage,
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              // New email
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: _newEmailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .changeEmailEmailInput_textformfield_myAccountWidgetChangeEmailPage,
                    prefixIcon: const Icon(Icons.mail),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              // Confirm new email
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: _confirmNewEmailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .changeEmailEmailInputConfirm_textformfield_myAccountWidgetChangeEmailPage,
                    prefixIcon: const Icon(Icons.mail),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              // Confirm button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  minimumSize: const Size(200, 60),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  changeEmail();
                },
                child: Text(
                  AppLocalizations.of(context)!
                      .changeEmailTitle_text_myAccountWidgetChangeEmailPage,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeEmail() async {
    try {
      if (_passwordLoginController.text.isEmpty) {
        ExceptionsAlertDialog.showErrorDialog(
            context: context,
            errorMessage: AppLocalizations.of(context)!
                .changeEmailNoPassword_exception_myAccountWidgetChangeEmailPageException);
        return;
      }

      if (_newEmailController.text.isEmpty ||
          _confirmNewEmailController.text.isEmpty) {
        ExceptionsAlertDialog.showErrorDialog(
            context: context,
            errorMessage: AppLocalizations.of(context)!
                .changeEmailNoEmails_exception_myAccountWidgetChangeEmailPageException);
        return;
      }

      if (_newEmailController.text != _confirmNewEmailController.text) {
        ExceptionsAlertDialog.showErrorDialog(
            context: context,
            errorMessage: AppLocalizations.of(context)!
                .changeEmailEmailDontMatch_exception_myAccountWidgetChangeEmailPageException);
        return;
      }

      if (_newEmailController.text == widget.currentUser.email!) {
        ExceptionsAlertDialog.showErrorDialog(
            context: context,
            errorMessage: AppLocalizations.of(context)!
                .changeEmailCurrentEmailIsSame_exception_myAccountWidgetChangeEmailPageException);
        return;
      }

      UserCredential reAuthCredentials =
          await AuthUserService.reAuthUserFirebase(
        context: context,
        email: widget.currentUser.email!,
        password: _passwordLoginController.text,
      );

      if (context.mounted) {
        await AuthUserService.changeEmailUserFirebase(
          updatedUser: reAuthCredentials,
          currentEmail: widget.currentUser.email!,
          password: _passwordLoginController.text,
          newEmail: _newEmailController.text,
          context: context,
        ).then(
          (result) {
            if (result != null && result == 'Success') {
              AuthUserService.logOutUserFirebase(context: context);
              Navigator.maybePop(context).then((_) {
                Navigator.maybePop(context).then((_) {
                  return showDialog(
                    context: context,
                    builder: (context) =>
                        SuccessfulMailSentRecoverPasswordDialog(
                      sucessMessage: AppLocalizations.of(context)!
                          .changeEmailSucess_dialog_myAccountWidgetChangeEmailPage,
                    ),
                  );
                });
              });
            }
          },
        );
      }
    } catch (errorMessage) {
      ExceptionsAlertDialog.showErrorDialog(
          context: context, errorMessage: errorMessage.toString());
    }
  }
}
