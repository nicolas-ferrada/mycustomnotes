import 'package:flutter/material.dart';

import '../../data/models/Note/note_model.dart';
import '../pages/email_verification_page/email_verification_page.dart';
import '../pages/home_page/home_page.dart';
import '../pages/login_page/login_page.dart';
import '../pages/note_create_page/note_create_page.dart';
import '../pages/note_details_page/note_details_page.dart';
import '../pages/password_recover_page/password_recover_page.dart';
import '../pages/register_page/register_page.dart';

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
        final note = settings.arguments as Note;
        return MaterialPageRoute(
            builder: (context) => NoteDetailsPage(note: note));
      case loginPageRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case registerPageRoute:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case emailVerificationPageRoute:
        return MaterialPageRoute(builder: (_) => const EmailVerificationPage());
      case recoverPasswordPageRoute:
        return MaterialPageRoute(builder: (_) => const PasswordRecoverPage());
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
