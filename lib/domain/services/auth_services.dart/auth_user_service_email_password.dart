import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/domain/services/auth_services.dart/auth_user_service.dart';

import '../../../l10n/l10n_export.dart';
import '../../../utils/extensions/formatted_message.dart';

class AuthUserServiceEmailPassword {
  static Future<void> registerEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (firebaseException) {
      if (!context.mounted) return;
      if (firebaseException.code == 'email-already-in-use') {
        throw Exception(AppLocalizations.of(context)!
                .emailAlreadyInUse_dialog_registerPage)
            .removeExceptionWord;
      } else if (firebaseException.code == 'invalid-email') {
        throw Exception(
                AppLocalizations.of(context)!.invalidEmail_dialog_registerPage)
            .removeExceptionWord;
      } else if (firebaseException.code == 'weak-password') {
        throw Exception(
                AppLocalizations.of(context)!.weakPassword_dialog_registerPage)
            .removeExceptionWord;
      } else if (firebaseException.code == 'unknown') {
        throw Exception(
                AppLocalizations.of(context)!.unknown_empty_dialog_registerPage)
            .removeExceptionWord;
      } else {
        throw Exception(AppLocalizations.of(context)!
                .genericRegisterException_dialog_registerPage)
            .removeExceptionWord;
      }
    } catch (unexpectedException) {
      if (!context.mounted) return;
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }

  static Future<void> logInInEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (exception) {
      if (!context.mounted) return;
      if (exception.code == 'wrong-password') {
        throw Exception(
                AppLocalizations.of(context)!.wrongPassword_dialog_loginPage)
            .removeExceptionWord;
      } else if (exception.code == 'user-not-found') {
        throw Exception(
                AppLocalizations.of(context)!.userNotFound_dialog_loginPage)
            .removeExceptionWord;
      } else if (exception.code == 'invalid-email') {
        throw Exception(
                AppLocalizations.of(context)!.invalidEmail_dialog_loginPage)
            .removeExceptionWord;
      } else if (exception.code == 'too-many-requests') {
        throw Exception(AppLocalizations.of(context)!
                .tooManyLoginRequests_dialog_loginPage)
            .removeExceptionWord;
      } else if (exception.code == 'unknown') {
        throw Exception(
                AppLocalizations.of(context)!.unknown_empty_dialog_loginPage)
            .removeExceptionWord;
      } else if (exception.code == 'network-request-failed') {
        throw Exception(AppLocalizations.of(context)!
                .networkRequestFailed_dialog_loginPage)
            .removeExceptionWord;
      } else {
        throw Exception(AppLocalizations.of(context)!
                .genericLoginException_dialog_loginPage)
            .removeExceptionWord;
      }
    } catch (unexpectedException) {
      if (!context.mounted) return;
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }

  static Future<void> emailVerificationEmailPassword({
    required BuildContext context,
  }) async {
    try {
      User currentUser = AuthUserService.getCurrentUser();
      if (currentUser.emailVerified == false) {
        await currentUser.sendEmailVerification();
      } else {
        throw Exception(AppLocalizations.of(context)!
            .emailAlreadyVerified_dialog_emailVerificationPage);
      }
    } catch (unexpectedException) {
      if (!context.mounted) return;
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }

  static Future<void> recoverPasswordEmailPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (firebaseException) {
      if (!context.mounted) return;
      if (firebaseException.code == 'invalid-email') {
        throw Exception(
          AppLocalizations.of(context)!.invalidEmail_dialog_recoverPasswordPage,
        ).removeExceptionWord;
      } else if (firebaseException.code == 'user-not-found') {
        throw Exception(AppLocalizations.of(context)!
                .userNotFound_dialog_recoverPassword)
            .removeExceptionWord;
      } else if (firebaseException.code == 'unknown') {
        throw Exception(AppLocalizations.of(context)!
                .unknown_empty_dialog_recoverPassword)
            .removeExceptionWord;
      } else {
        throw Exception(AppLocalizations.of(context)!
                .genericRecoverPasswordException_dialog_recoverPasswordPage)
            .removeExceptionWord;
      }
    } catch (unexpectedException) {
      if (!context.mounted) return;
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }

  static Future<UserCredential> reAuthUserEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      User currentUser = AuthUserService.getCurrentUser();
      UserCredential reAuthedUser =
          await currentUser.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: email,
          password: password,
        ),
      );
      return reAuthedUser;
    } on FirebaseAuthException catch (firebaseException) {
      if (!context.mounted) throw Exception();
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
      if (!context.mounted) throw Exception();
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }
}
