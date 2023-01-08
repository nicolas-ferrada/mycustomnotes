import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/auth_functions/auth_sqlite_functions.dart';
import 'package:mycustomnotes/constants/routes.dart';
import 'package:mycustomnotes/database/sqlite/database_helper.dart';
import 'package:mycustomnotes/auth_functions/auth_firebase_functions.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as dev;

import '../../models/user_model.dart';

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
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.mail),
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
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
                label: const Text(
                  'Login',
                  style: TextStyle(fontSize: 30),
                ),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 30),
                  backgroundColor: Color.fromRGBO(250, 216, 90, 0.9),
                  minimumSize: const Size(220, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.all(10),
                ),
                onPressed: () async {
                  String email = _emailLoginController.text;
                  String password = _passwordLoginController.text;
                  // sqlite login
                  await AuthSqliteFunctions.loginSqliteUser(email, password);

                  // firebase login
                  await AuthFirebaseFunctions.loginFirebase(email, password, context);

                  // I SHOULD CREATE SQLITE USER ON SUCCESS LOGIN!!!
                },
              ),
            ),
            //Rich text 'need an account?' Sign up
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.grey, fontSize: 20),
                    text: 'Need an account? ',
                    children: [
                      TextSpan(
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white),
                          text: 'Sign up',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, registerRoute);
                            }),
                    ]),
              ),
            ),
            //Rich text text Forgot your password? Recover it
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.grey, fontSize: 20),
                  text: 'Forgot your password? ',
                  children: [
                    TextSpan(
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white),
                      text: 'Recover it',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, recoverPasswordRoute);
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
