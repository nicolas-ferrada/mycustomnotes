import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

import '../../../domain/services/auth_user_service.dart';
import '../../../domain/services/user_configuration_service.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../home_page/home_page.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late User currentUser;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    currentUser = AuthUserService.getCurrentUserFirebase();
    userVerifyEmail();
  }

  Future<void> userVerifyEmail() async {
    // If current user's email is not verified, send the email verification to it's email
    if (currentUser.emailVerified == false) {
      try {
        AuthUserService
            .emailVerificationUserFirebase(); // Sends the email verification
        // Check every three seconds if the user is verified or not, when it is, stop checking.
        timer = Timer.periodic(
          const Duration(seconds: 3),
          (_) async {
            if (currentUser.emailVerified == false) {
              await currentUser.reload();
              currentUser = AuthUserService
                  .getCurrentUserFirebase(); // Get a new instace after reload.
            } else {
              // User is verified for the first time, so create it's configuration
              await UserConfigurationService.createUserConfigurations(
                  userId: currentUser.uid);
              timer?.cancel();
              setState(() {});
            }
          },
        );
      } catch (errorMessage) {
        ExceptionsAlertDialog.showErrorDialog(context, errorMessage.toString());
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser.emailVerified == true) {
      //If email is verified, sends you to the home page, if not, keeps you here
      return const HomePage();
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Email verification'),
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
                '${currentUser.email}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () async {
                  // Log out firebase
                  try {
                    await AuthUserService.logOutUserFirebase();
                  } catch (errorMessage) {
                    ExceptionsAlertDialog.showErrorDialog(
                        context, errorMessage.toString());
                  }
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  "Can't verify the email? sign out",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
