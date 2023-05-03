import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../domain/services/auth_user_service.dart';
import '../../../l10n/l10n_export.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../routes/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailLoginController = TextEditingController();
  final _passwordLoginController = TextEditingController();

  @override
  void dispose() {
    _emailLoginController.dispose();
    _passwordLoginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Custom Notes',
          style: TextStyle(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Mail user input
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _emailLoginController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.email_textformfield,
                  prefixIcon: const Icon(Icons.mail),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            //Password user input
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordLoginController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context)!.password_textformfield,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            //Login button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.lock_open,
                  size: 32,
                ),
                label: Text(
                  AppLocalizations.of(context)!.login_button,
                  style: const TextStyle(fontSize: 30),
                ),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 30),
                  backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
                  minimumSize: const Size(220, 70),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                ),
                onPressed: () async {
                  // Login firebase.
                  try {
                    await AuthUserService.loginUserFirebase(
                      email: _emailLoginController.text,
                      password: _passwordLoginController.text,
                      context: context,
                    );
                  } catch (errorMessage) {
                    ExceptionsAlertDialog.showErrorDialog(
                        context, errorMessage.toString());
                  }
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            //Rich text 'need an account?' Sign up
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.grey, fontSize: 18),
                    text: AppLocalizations.of(context)!.signUp_text_info,
                    children: [
                      TextSpan(
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white),
                          text: AppLocalizations.of(context)!.signUp_richText,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, registerPageRoute);
                            }),
                    ]),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            //Rich text text Forgot your password? Recover it
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                  text: AppLocalizations.of(context)!.passwordRecover_text_info,
                  children: [
                    TextSpan(
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white),
                      text: AppLocalizations.of(context)!
                          .passwordRecover_richText,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                              context, recoverPasswordPageRoute);
                        },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
