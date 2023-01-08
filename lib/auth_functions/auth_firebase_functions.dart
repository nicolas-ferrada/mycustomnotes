import 'package:firebase_auth/firebase_auth.dart';
import 'package:mycustomnotes/exceptions/auth_firebase_exceptions.dart';
import 'package:flutter/material.dart';

class AuthFirebaseFunctions {
  //Logs in a user with it's email and password
  static Future loginFirebase(
      String email, String password, BuildContext context) async {
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

  //Register/create a new user
  static Future registerFirebaseUser(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential newUser =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return newUser;
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

  //Log out the current user
  static Future logoutFirebase(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (unexpectedException) {
      AuthFirebaseExceptions.showErrorDialog(
          context, "There is a unexpected error:\n$unexpectedException");
    }
  }

  //Send a verification email to the current user
  static Future sendVerificationEmail(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (unexpectedException) {
      AuthFirebaseExceptions.showErrorDialog(
          context, "There is a unexpected error:\n$unexpectedException");
    }
  }

  //Recover the password of the specified mail sending it an email
  static Future recoverPassword(String email, BuildContext context) async {
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
}
