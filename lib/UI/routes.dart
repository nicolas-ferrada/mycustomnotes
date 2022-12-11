import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/home_page.dart';
import 'package:mycustomnotes/UI/pages/login_page.dart';
import 'package:mycustomnotes/UI/pages/recover_password_page.dart';
import 'package:mycustomnotes/UI/pages/register_page.dart';

class Routes extends StatelessWidget {
  const Routes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My custom notes',
      theme: ThemeData.dark(),
      initialRoute: '/LoginPage',
      routes: {
        '/LoginPage': (context) => const LoginPage(),
        '/RegisterPage': (context) => const RegisterPage(),
        '/HomePage': (context) => const HomePage(),
        '/RecoverPassword': (context) => const RecoverPassword(),
      },
      //home: const MainPage(),
    );
  }
}
