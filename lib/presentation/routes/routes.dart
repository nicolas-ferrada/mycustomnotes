import 'package:flutter/material.dart';
import 'package:mycustomnotes/presentation/pages/email_verification_page.dart';
import 'package:mycustomnotes/presentation/pages/home_page.dart';
import 'package:mycustomnotes/presentation/pages/login_page.dart';
import 'package:mycustomnotes/presentation/pages/note_create_page.dart';
import 'package:mycustomnotes/presentation/pages/note_details_page.dart';
import 'package:mycustomnotes/presentation/pages/recover_password_page.dart';
import 'package:mycustomnotes/presentation/pages/register_page.dart';

// Routes
const String homePageRoute = '/';
const String noteCreatePageRoute = '/noteCreatePage';
const String noteDetailsPageRoute = '/noteDetailsPage';
const String loginPageRoute = '/loginPage';
const String registerPageRoute = '/registerPage';
const String emailVerificationPageRoute = '/emailVerificationPage';
const String recoverPasswordPageRoute = '/recoverPasswordPage';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePageRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case noteCreatePageRoute:
        return MaterialPageRoute(builder: (_) => const NoteCreatePage());
      case noteDetailsPageRoute:
        return MaterialPageRoute(builder: (_) => const NoteDetailsPage());
      case loginPageRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case registerPageRoute:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case emailVerificationPageRoute:
        return MaterialPageRoute(builder: (_) => const EmailVerificationPage());
      case recoverPasswordPageRoute:
        return MaterialPageRoute(builder: (_) => const RecoverPasswordPage());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorPage());
    }
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Route not found')),
    );
  }
}
