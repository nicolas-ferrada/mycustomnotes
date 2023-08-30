import 'package:flutter/material.dart';

import '../../../domain/services/auth_user_service.dart';
import '../../../l10n/l10n_export.dart';
import '../../../utils/app_color_scheme/app_color_scheme.dart';
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
    _passwordConfirmRegisterController.dispose();
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: _emailRegisterController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .email_textformfield_registerPage,
                    prefixIcon: const Icon(Icons.mail),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColorScheme.purple(),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Password user input
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: _passwordRegisterController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: AppLocalizations.of(context)!
                        .password_textformfield_registerPage,
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
              // Confirm password user input
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: _passwordConfirmRegisterController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: AppLocalizations.of(context)!
                        .confirmPassword_textformfield_registerPage,
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
              const SizedBox(height: 16),
              //Register button
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
                    // Check if password and confirm password are equal
                    if (_passwordRegisterController.text !=
                        _passwordConfirmRegisterController.text) {
                      ExceptionsAlertDialog.showErrorDialog(
                          context: context,
                          errorMessage: AppLocalizations.of(context)!
                              .confirmPasswordInvalid_dialog_registerPage);
                      return;
                    }

                    if (_emailRegisterController.text.isEmpty ||
                        _passwordRegisterController.text.isEmpty ||
                        _passwordConfirmRegisterController.text.isEmpty) {
                      ExceptionsAlertDialog.showErrorDialog(
                        context: context,
                        errorMessage: AppLocalizations.of(context)!
                            .unknown_empty_dialog_registerPage,
                      );
                      return;
                    }

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
                  },
                  child: Text(
                    AppLocalizations.of(context)!
                        .createAccount_button_registerPage,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
