import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/presentation/pages/email_verification_page.dart';
import 'package:mycustomnotes/presentation/routes/routes.dart';

import 'presentation/pages/login_page.dart';


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
      onGenerateRoute: AppRoutes.generateRoute,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const EmailVerificationPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
