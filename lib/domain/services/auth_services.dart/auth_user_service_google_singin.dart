import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mycustomnotes/domain/services/auth_services.dart/auth_user_service.dart';
import 'package:mycustomnotes/presentation/widgets/privacy_policy_terms_of_service_widget/privacy_policy_terms_of_service_dialog.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';

import '../../../l10n/l10n_export.dart';

class AuthUserServiceGoogleSignIn {
  static Future<void> logInGoogle(context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      // Accept Privacy Policy and Terms of Service
      // Since I did not find any way to check if user is creating an account or just logging in,
      // so I could only ask for consent only when they are signing up, I just ask every time
      // until I find other more user comfortable approuch
      bool? didUserAccepted = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const PrivacyPolicyTermsOfServiceDialog(),
      );

      if (didUserAccepted == false || didUserAccepted == null) {
        AuthUserService.logOut();
        throw Exception(AppLocalizations.of(context)!
                .pptosWereNotAccepted_exception_pptos)
            .removeExceptionWord;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // This will create the account if it does not exist.
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Special exception usually cause for spamming the google button.
      if (e.toString() ==
          'PlatformException(channel-error, Unable to establish connection on channel., null, null)') {
        throw Exception(
          AppLocalizations.of(context)!.googleLoginTooFast_dialog_loginPage,
        ).removeExceptionWord;
      }
      throw Exception(e).removeExceptionWord;
    }
  }

  static Future<UserCredential?> reAuthUserGoogle({
    required String email,
    required BuildContext context,
  }) async {
    try {
      User currentUser = AuthUserService.getCurrentUser();

      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signInSilently();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      UserCredential reAuthedUser =
          await currentUser.reauthenticateWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ),
      );
      return reAuthedUser;
    } on FirebaseAuthException catch (firebaseException) {
      if (!context.mounted) return null;
      if (firebaseException.code == 'user-mismatch') {
        throw Exception(AppLocalizations.of(context)!
                .changeEmailUserMismatch_exception_myAccountWidgetChangeEmailPageException)
            .removeExceptionWord;
      } else if (firebaseException.code == 'user-not-found') {
        throw Exception(AppLocalizations.of(context)!
                .changeEmailUserNotFound_exception_myAccountWidgetChangeEmailPageException)
            .removeExceptionWord;
      } else if (firebaseException.code == 'invalid-credential') {
        throw Exception(AppLocalizations.of(context)!
                .changeEmailInvalidCredentials_exception_myAccountWidgetChangeEmailPageException)
            .removeExceptionWord;
      } else if (firebaseException.code == 'invalid-email') {
        throw Exception(AppLocalizations.of(context)!
                .changeEmailInvalidEmail_exception_myAccountWidgetChangeEmailPageException)
            .removeExceptionWord;
      } else if (firebaseException.code == 'wrong-password') {
        throw Exception(AppLocalizations.of(context)!
                .changeEmailWrongPassword_exception_myAccountWidgetChangeEmailPageException)
            .removeExceptionWord;
      } else {
        throw Exception(AppLocalizations.of(context)!
                .changeEmailGeneric_exception_myAccountWidgetChangeEmailPageException)
            .removeExceptionWord;
      }
    } catch (unexpectedException) {
      if (!context.mounted) return null;
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }
}
