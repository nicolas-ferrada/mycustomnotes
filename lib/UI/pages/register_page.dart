import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailRegisterController = TextEditingController();
  final _passwordRegisterController = TextEditingController();

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
        title: const Text('Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Mail user input
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailRegisterController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            //password user input
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordRegisterController,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            //Register button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
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
                  _registerFirebaseUser(_emailRegisterController.text,
                      _passwordRegisterController.text);
                },
                child: const Text('Register new user'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future _registerFirebaseUser(String email, String password) async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
}
