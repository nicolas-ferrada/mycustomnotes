import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/auth_functions/auth_sqlite_functions.dart';
import '../../auth_functions/auth_firebase_functions.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailRegisterController = TextEditingController();
  final _passwordRegisterController = TextEditingController();
  bool _isBackButtonDisabled = false;

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_isBackButtonDisabled == true) {
              return; //does nothing
            } else {
              Navigator.maybePop(context);
            }
          },
        ),
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
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
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
                onPressed: () async {
                  // Prevents user leaving screen
                  setState(() {
                    _isBackButtonDisabled = true;
                  });
                  String email = _emailRegisterController.text;
                  String password = _passwordRegisterController.text;
                  // Firebase
                  final UserCredential uidFirebase =
                      await AuthFirebaseFunctions.registerFirebaseUser(
                          email, password);

                  // Sqlite
                  await AuthSqliteFunctions.registerSqliteUser(
                          uid: uidFirebase.user!.uid,
                          email: email,
                          password: password)
                      .then(
                    (value) {
                      // If the login was success then pop, if not, exception and unlock back button!!!
                      Navigator.maybePop(context);
                    },
                  );
                  ;
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
