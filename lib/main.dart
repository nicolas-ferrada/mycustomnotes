import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/create_note_page.dart';
import 'package:mycustomnotes/UI/pages/verification_email.dart';
import 'package:mycustomnotes/constants/routes.dart';
import 'package:mycustomnotes/notifiers/note_model_notifier.dart';
import 'package:provider/provider.dart';

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
        verificationEmailRoute: (context) => const VerificationEmail(),
        createNoteRoute: (context) => const CreateNote(),
      },
      home: ChangeNotifierProvider(
        create: (context) => NoteModelNotifier(),
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const VerificationEmail();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
