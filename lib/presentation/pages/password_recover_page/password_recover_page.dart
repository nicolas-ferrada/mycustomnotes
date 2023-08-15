import 'package:flutter/material.dart';
import 'package:mycustomnotes/utils/dialogs/successful_mail_sent_recover_pasword_dialog.dart';

import '../../../domain/services/auth_user_service.dart';
import '../../../l10n/l10n_export.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';

class PasswordRecoverPage extends StatefulWidget {
  const PasswordRecoverPage({super.key});

  @override
  State<PasswordRecoverPage> createState() => _PasswordRecoverPageState();
}

class _PasswordRecoverPageState extends State<PasswordRecoverPage> {
  final _emailRecoverPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailRecoverPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            AppLocalizations.of(context)!.title_appbar_recoverPasswordPage),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Explanation to the user
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                AppLocalizations.of(context)!
                    .instructions_text_recoverPasswordPage,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            //Mail user input
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                controller: _emailRecoverPasswordController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!
                      .email_textformfield_recoverPasswordPage,
                  prefixIcon: const Icon(Icons.mail),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            //Button recover password
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.lock,
                  size: 32,
                ),
                label: Text(
                  AppLocalizations.of(context)!
                      .resetPassword_button_recoverPasswordPage,
                  style: const TextStyle(fontSize: 24),
                ),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 30),
                  backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
                  minimumSize: const Size(220, 70),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                ),
                onPressed: () async {
                  // Send a email to recover the access of the account of the specified mail
                  try {
                    await AuthUserService.recoverPasswordUserFirebase(
                      email: _emailRecoverPasswordController.text,
                      context: context,
                    ).then(
                      (_) => Navigator.maybePop(context).then(
                        (_) => showDialog(
                          context: context,
                          builder: (context) =>
                              SuccessfulMailSentRecoverPasswordDialog(
                            sucessMessage: AppLocalizations.of(context)!
                                .sucessfulMailSent_body_dialog_recoverPasswordPage,
                          ),
                        ),
                      ),
                    );
                  } catch (errorMessage) {
                    // errorMessage is the custom message sent by the firebase function.
                    ExceptionsAlertDialog.showErrorDialog(
                        context: context,
                        errorMessage: errorMessage.toString());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
