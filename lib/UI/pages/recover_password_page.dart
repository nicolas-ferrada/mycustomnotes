import 'package:flutter/material.dart';
import '/firebase_functions/firebase_auth.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
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
        title: const Text('Recover password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            //Button recover password
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.lock_open,
                  size: 32,
                ),
                label: const Text(
                  'Recover password',
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
                  FirebaseFunctions.recoverPassword(
                      _emailRecoverPasswordController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
