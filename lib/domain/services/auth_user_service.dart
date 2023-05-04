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
      throw Exception().removeExceptionWord;
    }
  }

  // Log out user firebase
  static Future<void> logOutUserFirebase() async {
    try {
      await FirebaseAuth.instance.signOut();
      await FirebaseFirestore.instance.terminate();
      await FirebaseFirestore.instance.clearPersistence();
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .removeExceptionWord;
    }
  }

  // Email verification user firebase
  static Future<void> emailVerificationUserFirebase() async {
    try {
      final currentUser = AuthUserService.getCurrentUserFirebase();
      if (currentUser.emailVerified == false) {
        await currentUser.sendEmailVerification();
      } else {
        throw Exception('The email is already verified');
      }
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .removeExceptionWord;
    }
  }

  // Recover password user firebase
  static Future<void> recoverPasswordUserFirebase({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (firebaseException) {
      if (firebaseException.code == 'invalid-email') {
        throw Exception("You have entered an invalid email")
            .removeExceptionWord;
      }
      if (firebaseException.code == 'user-not-found') {
        throw Exception("The entered account doesn't exist")
            .removeExceptionWord;
      }
      if (firebaseException.code == 'unknown') {
        throw Exception("You have to type an email and password")
            .removeExceptionWord;
      } else {
        throw Exception(
                "There is a problem recovering your password:\n$firebaseException")
            .removeExceptionWord;
      }
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
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
        throw Exception("There is no user logged in").removeExceptionWord;
      }
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .removeExceptionWord;
    }
  }
}
