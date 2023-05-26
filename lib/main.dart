import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'data/models/Note/note_notifier.dart';
import 'l10n/change_language.dart';
import 'l10n/l10n_locale_provider.dart';
import 'presentation/pages/email_verification_page/email_verification_page.dart';
import 'presentation/pages/login_page/login_page.dart';
import 'presentation/routes/routes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  // if language is null, (no record in db) it will return device language, if not en/es, use en
  final String language = await ChangeLanguage.getLanguage();
  runApp(MyApp(language: language));
}

class MyApp extends StatelessWidget {
  final String language;
  const MyApp({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoteNotifier>(
          create: (_) => NoteNotifier(),
        ),
        ChangeNotifierProvider<L10nLocaleProvider>(
          create: (_) => L10nLocaleProvider(language: language),
        ),
      ],
      child: Consumer<L10nLocaleProvider>(
          builder: (context, l10nLocaleProvider, child) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: L10n.all,
          locale: l10nLocaleProvider.locale,
          debugShowCheckedModeBanner: false,
          title: 'My Custom Notes',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.dark(
              background: Colors.grey.shade900,
              primary: Colors.white60,
            ),
          ),
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
      }),
    );
  }
}
