import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseFunctions {
  //Register/create a new user
  static Future registerFirebaseUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } catch (registerError) {
      final snackBarMsg = SnackBar(content: Text(registerError.toString()));
      //Scaffold.of(context).showSnackBar(snackBarMsg);
    }
  }

  //Logs in a user with it's email and password
  static Future loginFirebase(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } catch (e) {
      print(e);
    }
  }

  //Log out the current user
  static Future logoutFirebase() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  //Send a verification email to the current user
  static Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      print(e);
    }
  }

  //Recover the password of the specified mail sending it an email
  static Future recoverPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      print(e);
    }
  }
}
