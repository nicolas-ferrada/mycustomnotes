import 'package:flutter/material.dart';
import 'package:mycustomnotes/utils/dialogs/successful_message_dialog.dart';

import '../../../domain/services/auth_user_service.dart';
import '../../../l10n/l10n_export.dart';
import '../../../utils/app_color_scheme/app_color_scheme.dart';
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
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            //Mail user input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextFormField(
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                controller: _emailRecoverPasswordController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!
                      .email_textformfield_recoverPasswordPage,
                  prefixIcon: const Icon(Icons.mail),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColorScheme.purple()),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            //Button recover password
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 30,
                  backgroundColor: AppColorScheme.darkPurple(),
                  minimumSize: const Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  // Send a email to recover the access of the account of the specified mail
                  try {
                    if (_emailRecoverPasswordController.text.isEmpty) {
                      ExceptionsAlertDialog.showErrorDialog(
                        context: context,
                        errorMessage: AppLocalizations.of(context)!
                            .unknown_empty_dialog_recoverPassword,
                      );
                      return;
                    }
                    await AuthUserService.recoverPasswordUserFirebase(
                      email: _emailRecoverPasswordController.text,
                      context: context,
                    ).then(
                      (_) => Navigator.maybePop(context).then(
                        (_) => showDialog(
                          context: context,
                          builder: (context) => SuccessfulMessageDialog(
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
                child: Text(
                  AppLocalizations.of(context)!
                      .resetPassword_button_recoverPasswordPage,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
