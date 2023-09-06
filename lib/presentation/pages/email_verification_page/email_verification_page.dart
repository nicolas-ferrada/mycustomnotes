import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter/material.dart';
import 'package:mycustomnotes/utils/enums/user_auth_provider.dart';

import '../../../domain/services/auth_services.dart/auth_user_service.dart';
import '../../../domain/services/auth_services.dart/auth_user_service_email_password.dart';
import '../../../domain/services/user_configuration_service.dart';
import '../../../l10n/l10n_export.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../home_page/home_page.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  User currentUser = FirebaseAuth.instance.currentUser!;
  Timer? timer;
  late final UserAuthProvider userAuthProvider;

  @override
  void initState() {
    super.initState();
    userAuthProvider = AuthUserService.getUserAuthProvider(
        currentUser: currentUser, context: context);
    userVerifyEmail();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> userVerifyEmail() async {
    // If current user's email is not verified, send the email verification to it's email
    if (currentUser.emailVerified == false &&
        userAuthProvider == UserAuthProvider.emailPassword) {
      try {
        AuthUserServiceEmailPassword.emailVerificationEmailPassword(
            context: context); // Sends the email verification
        // Check every three seconds if the user is verified or not, when it is, stop checking.
        timer = Timer.periodic(
          const Duration(seconds: 3),
          (_) async {
            if (currentUser.emailVerified == false) {
              await currentUser.reload();
              await currentUser.getIdToken(true);
              currentUser = FirebaseAuth
                  .instance.currentUser!; // Get a new instace after reload.
            } else {
              // User is verified for the first time, so create it's configuration
              await UserConfigurationService.createUserConfigurations(
                  context: context, userId: currentUser.uid);
              timer?.cancel();
              setState(() {});
            }
          },
        );
      } catch (errorMessage) {
        ExceptionsAlertDialog.showErrorDialog(
            context: context, errorMessage: errorMessage.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser.emailVerified == true) {
      //If email is verified, sends you to the home page, if not, keeps you here
      return const HomePage();
    } else {
      if (currentUser.emailVerified == false &&
              userAuthProvider == UserAuthProvider.google ||
          userAuthProvider == UserAuthProvider.emailPasswordAndGoogle) {
        // If user using Google, changes their email, they should not log in using the old account
        // and get the verify email sent, otherwise, the new and the old account will be linked to
        // their account. Since only logging in the new account by google will make their email
        // verified, is only necessary to avoid sending emailVerificationEmailPassword in this case.
        // After first login with the new email, old account will be unlinked.
        // Sadly this makes user with both providers, only be able to use google and not password.
        return googleAccountTryingToVerifyEmail(context);
      } else {
        return emailVerificationWidget(context);
      }
    }
  }

  Widget googleAccountTryingToVerifyEmail(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                AppLocalizations.of(context)!
                    .errorGoogleLoginOldAccountAfterEmailChange_text_emailVerificationPage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(200, 60),
                ),
                onPressed: () async {
                  // Log out firebase
                  try {
                    await AuthUserService.logOut(context: context);
                  } catch (errorMessage) {
                    ExceptionsAlertDialog.showErrorDialog(
                        context: context,
                        errorMessage: errorMessage.toString());
                  }
                },
                icon: const Icon(Icons.arrow_back),
                label: Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.logOut_drawer_homePage,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget emailVerificationWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            AppLocalizations.of(context)!.title_appbar_emailVerificationPage),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .infoMailSentTo_text_emailVerificationPage,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!
                  .userEmail_text_emailVerificationPage(
                      currentUser.email ?? 'Error: No email found'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(200, 60),
                ),
                onPressed: () async {
                  // Log out firebase
                  try {
                    await AuthUserService.logOut(context: context);
                  } catch (errorMessage) {
                    ExceptionsAlertDialog.showErrorDialog(
                        context: context,
                        errorMessage: errorMessage.toString());
                  }
                },
                icon: const Icon(Icons.arrow_back),
                label: Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!
                      .signOut_button_emailVerificationPage,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
