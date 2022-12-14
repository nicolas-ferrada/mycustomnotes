import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/home_page.dart';
import 'package:mycustomnotes/UI/pages/login_page.dart';
import 'package:mycustomnotes/UI/pages/recover_password_page.dart';
import 'package:mycustomnotes/UI/pages/register_page.dart';
import 'package:mycustomnotes/constants/routes.dart';

class AfterMain extends StatelessWidget {
  const AfterMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My custom notes',
      theme: ThemeData.dark(),
      initialRoute: loginRoute,
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterPage(),
        homeRoute: (context) => const HomePage(),
        recoverPasswordRoute: (context) => const RecoverPassword(),
      },
      //home: const MainPage(),
    );
  }
}
