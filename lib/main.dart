import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/verification_email.dart';
import 'package:mycustomnotes/constants/routes.dart';

import 'UI/pages/home_page.dart';
import 'UI/pages/login_page.dart';
import 'UI/pages/recover_password_page.dart';
import 'UI/pages/register_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My custom notes',
      theme: ThemeData.dark(),
      initialRoute: null,
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterPage(),
        homeRoute: (context) => const HomePage(),
        recoverPasswordRoute: (context) => const RecoverPassword(),
        verificationEmailRoute: (context) => const VerificationEmail()
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const VerificationEmail();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
