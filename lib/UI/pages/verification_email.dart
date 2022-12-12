import 'dart:async';
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
  final user = FirebaseAuth.instance.currentUser!;
  Timer? timer;

  @override
  void initState() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (isEmailVerified == false) {
      _sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(), //why _
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified == true) {
      timer?.cancel();
    }
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "The verification mail was sent to:",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                '${user.email}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  _logoutFirebase();
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  "Can't verify the email? sign out",
                  style: TextStyle(fontSize: 24),
                ),
              )
            ],
          ),
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

Future _logoutFirebase() async {
  await FirebaseAuth.instance.signOut();
}
