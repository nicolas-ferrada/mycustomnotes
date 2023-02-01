import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../database/sqlite/database_helper.dart';
import '../exceptions/auth_firebase_exceptions.dart';
import '../models/user_model.dart';

class AuthUserService {
  // Register user firebase and returns an AuthUser object
  static Future registerUserFirebase({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final UserCredential newUser =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return AuthUser(email: email, password: password, id: newUser.user!.uid);
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'email-already-in-use') {
        AuthFirebaseExceptions.showErrorDialog(
            context, 'You have entered an email that is already in use');
      }
      if (exception.code == 'invalid-email') {
        AuthFirebaseExceptions.showErrorDialog(
            context, "You have entered an invalid email");
      }
      if (exception.code == 'weak-password') {
        AuthFirebaseExceptions.showErrorDialog(
            context, "You have entered a weak password");
      }
      if (exception.code == 'unknown') {
        AuthFirebaseExceptions.showErrorDialog(
            context, "You have to type an email and password");
      } else {
        AuthFirebaseExceptions.showErrorDialog(context,
            "There is a problem with your register process:\n$exception");
      }
    } catch (unexpectedException) {
      AuthFirebaseExceptions.showErrorDialog(
          context, "There is a unexpected error:\n$unexpectedException");
    }
  }

  // Register user sqlite using the AuthUser object retured by registerUserFirebase.
  static Future registerUserSqlite({
    required AuthUser user,
    required BuildContext context,
  }) async {
    try {
      await DatabaseHelper.instance.createUser(user);
    } catch (unexpectedException) {
      AuthFirebaseExceptions.showErrorDialog(context,
          "There is a unexpected error with the local register process:\n$unexpectedException");
    }
  }

  // Login user firebase
  static Future loginUserFirebase({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'wrong-password') {
        AuthFirebaseExceptions.showErrorDialog(
            context, 'You have entered a wrong password');
      } else if (exception.code == 'user-not-found') {
        AuthFirebaseExceptions.showErrorDialog(
            context, "The entered account doesn't exist");
      } else if (exception.code == 'invalid-email') {
        AuthFirebaseExceptions.showErrorDialog(
            context, "The entered email is not valid");
      } else if (exception.code == 'unknown') {
        AuthFirebaseExceptions.showErrorDialog(
            context, "You have to type an email and password");
      } else if (exception.code == 'network-request-failed') {
        AuthFirebaseExceptions.showErrorDialog(
            context, "You have to be connected to internet");
      } else {
        AuthFirebaseExceptions.showErrorDialog(
            context, "There is a problem with your login:\n$exception");
      }
    } catch (unexpectedException) {
      AuthFirebaseExceptions.showErrorDialog(
          context, "There is a unexpected error:\n$unexpectedException");
    }
  }

  // Login user sqlite (not used)
  static Future<void> loginUserSqlite({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await DatabaseHelper.instance.loginUser(email, password);
    } catch (unexpectedException) {
      AuthFirebaseExceptions.showErrorDialog(context,
          "There is a unexpected error with the local login:\n$unexpectedException");
    }
  }

  // Log out user firebase
  static Future logOutUserFirebase(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (unexpectedException) {
      AuthFirebaseExceptions.showErrorDialog(
          context, "There is a unexpected error:\n$unexpectedException");
    }
  }

  // Log out user Sqlite
  // Close db?

  // Email verification user firebase
  static Future emailVerificationUserFirebase(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (unexpectedException) {
      AuthFirebaseExceptions.showErrorDialog(
          context, "There is a unexpected error:\n$unexpectedException");
    }
  }

  // Email verification user sqlite
  // Needed? save it after?

  // Recover password user firebase
  static Future recoverPasswordUserFirebase({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'invalid-email') {
        AuthFirebaseExceptions.showErrorDialog(
            context, "You have entered an invalid email");
      }
      if (exception.code == 'user-not-found') {
        AuthFirebaseExceptions.showErrorDialog(
            context, "The entered account doesn't exist");
      }
      if (exception.code == 'unknown') {
        AuthFirebaseExceptions.showErrorDialog(
            context, "You have to type an email and password");
      } else {
        AuthFirebaseExceptions.showErrorDialog(context,
            "There is a problem recovering your password:\n$exception");
      }
    } catch (unexpectedException) {
      AuthFirebaseExceptions.showErrorDialog(
          context, "There is a unexpected error:\n$unexpectedException");
    }
  }

  // Recover user password sqlite
  // needed? need to change the password aswell?
}
