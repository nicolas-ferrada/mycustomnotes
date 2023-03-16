import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'data/models/Note/note_notifier.dart';
import 'presentation/pages/email_verification_page/email_verification_page.dart';
import 'presentation/routes/routes.dart';

import 'presentation/pages/login_page/login_page.dart';

import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteNotifier(),
      child: MaterialApp(
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
      ),
    );
  }
}
