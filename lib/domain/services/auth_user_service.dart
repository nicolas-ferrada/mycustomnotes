import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../l10n/l10n_export.dart';
import '../../utils/extensions/formatted_message.dart';

class AuthUserService {
  // Register an user with email and password on firebase
  static Future<void> registerUserEmailPasswordFirebase({
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
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }

  // Login user firebase
  static Future<void> loginUserFirebase({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (exception) {
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
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }

  // Log out user firebase
  static Future<void> logOutUserFirebase({
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signOut();
      await FirebaseFirestore.instance.terminate();
      await FirebaseFirestore.instance.clearPersistence();
    } catch (unexpectedException) {
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }

  // Email verification user firebase
  static Future<void> emailVerificationUserFirebase({
    required BuildContext context,
  }) async {
    try {
      final currentUser = AuthUserService.getCurrentUserFirebase();
      if (currentUser.emailVerified == false) {
        await currentUser.sendEmailVerification();
      } else {
        throw Exception(AppLocalizations.of(context)!
            .emailAlreadyVerified_dialog_emailVerificationPage);
      }
    } catch (unexpectedException) {
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }

  // Recover password user firebase
  static Future<void> recoverPasswordUserFirebase({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (firebaseException) {
      if (firebaseException.code == 'invalid-email') {
        throw Exception(AppLocalizations.of(context)!
                .invalidEmail_dialog_recoverPasswordPage)
            .removeExceptionWord;
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
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }

  // Change email user firebase
  static Future<String?> changeEmailUserFirebase({
    required String currentEmail,
    required String password,
    required String newEmail,
    required UserCredential updatedUser,
    required BuildContext context,
  }) async {
    try {
      String operationResult = '';
      await updatedUser.user!
          .updateEmail(newEmail)
          .then((_) => operationResult = 'Success');
      return operationResult;
    } on FirebaseAuthException catch (firebaseException) {
      if (firebaseException.code == 'invalid-email') {
        throw Exception(AppLocalizations.of(context)!
                .changeEmailInvalidEmail_exception_myAccountWidgetChangeEmailPageException)
            .removeExceptionWord;
      } else if (firebaseException.code == 'email-already-in-use') {
        throw Exception(AppLocalizations.of(context)!
                .changeEmailEmailAlreadyInUse_exception_myAccountWidgetChangeEmailPageException)
            .removeExceptionWord;
      } else if (firebaseException.code == 'requires-recent-login') {
        throw Exception(AppLocalizations.of(context)!
                .changeEmailRecentLoginNeeded_exception_myAccountWidgetChangeEmailPageException)
            .removeExceptionWord;
      } else {
        throw Exception(AppLocalizations.of(context)!
                .genericRecoverPasswordException_dialog_recoverPasswordPage)
            .removeExceptionWord;
      }
    } catch (unexpectedException) {
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }

  // ReAuth a user firebase
  static Future<UserCredential> reAuthUserFirebase({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      User currentUser = getCurrentUserFirebase();
      UserCredential reAuthedUser =
          await currentUser.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: email,
          password: password,
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

  // Get current user logged on firebase
  static User getCurrentUserFirebase() {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return currentUser;
      } else {
        throw Exception("No user logged").removeExceptionWord;
      }
    } catch (unexpectedException) {
      throw Exception("Error").removeExceptionWord;
    }
  }
}
