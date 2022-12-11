import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/home_page.dart';

class VerificationEmail extends StatefulWidget {
  const VerificationEmail({super.key});

  @override
  State<VerificationEmail> createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<VerificationEmail> {
  bool isEmailVerified = false;

  @override
  void initState() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (isEmailVerified == false) {
      _sendVerificationEmail();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified == true) {
      //if email is verified, sends you to the home page, if not, keeps you here
      return const HomePage();
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Verify your email'),
        ),
      );
    }
  }
}

Future _sendVerificationEmail() async {
  try {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  } catch (error) {
    print(error);
  }
}
