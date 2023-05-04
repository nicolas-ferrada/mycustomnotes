import 'package:flutter/material.dart';

import '../../../domain/services/auth_user_service.dart';
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
        title: const Text('Reset password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Explanation to the user
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Enter your email to reset your password.',
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
                controller: _emailRecoverPasswordController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.mail),
                  border: OutlineInputBorder(),
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
                  'Reset password',
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
                      (_) => Navigator.maybePop(context)
                          .then((_) => dialogSucessfulMailSent(context)),
                    );
                  } catch (errorMessage) {
                    // errorMessage is the custom message sent by the firebase function.
                    ExceptionsAlertDialog.showErrorDialog(
                        context, errorMessage.toString());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> dialogSucessfulMailSent(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: const Color.fromARGB(255, 7, 202, 40),
          title: const Center(
            child: Text('Successful'),
          ),
          content: const Text(
            'An email to reset your password was sent.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Navigator.maybePop(context);
              },
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
