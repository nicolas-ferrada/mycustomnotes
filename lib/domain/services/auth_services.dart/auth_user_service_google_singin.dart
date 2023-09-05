import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mycustomnotes/domain/services/auth_services.dart/auth_user_service.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';

import '../../../l10n/l10n_export.dart';

class AuthUserServiceGoogleSignIn {
  static Future<UserCredential?> logInGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw Exception(e);
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
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }
}
