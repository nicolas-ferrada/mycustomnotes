import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/home_page.dart';
import 'package:mycustomnotes/UI/pages/verification_email.dart';

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
        title: const Text('My Custom Notes'),
      ),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.hasData) {
              return const VerificationEmail();
            }
            return Center(
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
                        backgroundColor: const Color.fromARGB(255, 221, 86, 76),
                        minimumSize: const Size(220, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        _loginFirebase(_emailLoginController.text,
                            _passwordLoginController.text);
                      },
                    ),
                  ),
                  //Button 'need an account?' Sign up
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 20),
                          text: 'Need an account? ',
                          children: [
                            TextSpan(
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white),
                                text: 'Sign up',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                        context, '/RegisterPage');
                                  }),
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 20),
                          text: 'Forgot your password? ',
                          children: [
                            TextSpan(
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white),
                                text: 'Recover it',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                        context, '/RecoverPassword');
                                  }),
                          ]),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

Future _loginFirebase(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  } catch (error) {
    print('Error $error');
  }
}
