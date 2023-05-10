import 'package:flutter/material.dart';

import '../../../domain/services/auth_user_service.dart';
import '../../../l10n/l10n_export.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailRegisterController = TextEditingController();
  final _passwordRegisterController = TextEditingController();
  final _passwordConfirmRegisterController = TextEditingController();

  @override
  void dispose() {
    _emailRegisterController.dispose();
    _passwordRegisterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.title_appbar_registerPage),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mail user input
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _emailRegisterController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .email_textformfield_registerPage,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Password user input
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _passwordRegisterController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .password_textformfield_registerPage,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              // Confirm password user input
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _passwordConfirmRegisterController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .confirmPassword_textformfield_registerPage,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              //Register button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.account_circle,
                    size: 32,
                  ),
                  label: Text(
                    AppLocalizations.of(context)!
                        .createAccount_button_registerPage,
                    style: const TextStyle(fontSize: 30),
                  ),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 30),
                    backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
                    minimumSize: const Size(220, 70),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 24),
                  ),
                  onPressed: () async {
                    // Check if password and confirm password are equal
                    if (_passwordRegisterController.text ==
                        _passwordConfirmRegisterController.text) {
                      // Register a user with email and password
                      try {
                        await AuthUserService.registerUserEmailPasswordFirebase(
                          email: _emailRegisterController.text,
                          password: _passwordRegisterController.text,
                          context: context,
                        ).then((_) => Navigator.maybePop(context));
                      } catch (errorMessage) {
                        // errorMessage is the custom message sent by the firebase function.
                        ExceptionsAlertDialog.showErrorDialog(
                            context: context,
                            errorMessage: errorMessage.toString());
                      }
                    } else {
                      ExceptionsAlertDialog.showErrorDialog(
                          context: context,
                          errorMessage: AppLocalizations.of(context)!
                              .confirmPasswordInvalid_dialog_registerPage);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
