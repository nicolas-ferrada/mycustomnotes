import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools;
//import 'package:flutter/material.dart';

class AuthFirebaseFunctions {
  //Logs in a user with it's email and password
  static Future loginFirebase(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'wrong-password') {
        devtools.log('The entered password is wrong.\n$exception');
      }
      if (exception.code == 'user-not-found') {
        devtools.log("The entered account doesn't exist.\n$exception");
      }
      if (exception.code == 'invalid-email') {
        devtools.log("The entered email is not valid.\n$exception");
      }
      if (exception.code == 'unknown') {
        devtools.log("You have to type an email and password.\n$exception");
      }
      if (exception.code == 'network-request-failed') {
        devtools.log("You have to be connected to internet.\n$exception");
      } else {
        devtools.log('There is a problem with your login.\n$exception');
      }
    } catch (unexpectedException) {
      devtools.log('Unexpected error, $unexpectedException');
    }
  }

  //Register/create a new user
  static Future registerFirebaseUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'email-already-in-use') {
        devtools.log(
            'You have entered an email that is already in use.\n$exception');
      }
      if (exception.code == 'invalid-email') {
        devtools.log("You have entered an invalid email.\n$exception");
      }
      if (exception.code == 'weak-password') {
        devtools.log("You have entered a weak password.\n$exception");
      }
      if (exception.code == 'unknown') {
        devtools.log("You have to type an email and password.\n$exception");
      } else {
        devtools.log('There is a problem with your register\n$exception');
      }
    } catch (unexpectedException) {
      devtools.log('Unexpected error, $unexpectedException');
    }
  }

  //Log out the current user
  static Future logoutFirebase() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      devtools.log('Unexpected exception, $error');
    }
  }

  //Send a verification email to the current user
  static Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (error) {
      devtools.log('Unexpected exception, $error');
    }
  }

  //Recover the password of the specified mail sending it an email
  static Future recoverPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'invalid-email') {
        devtools.log('You have entered an invalid email.\n$exception');
      }
      if (exception.code == 'user-not-found') {
        devtools.log("The entered account doesn't exist.\n$exception");
      }
      if (exception.code == 'unknown') {
        devtools.log("You have to type an email.\n$exception");
      } else {
        devtools.log('There is a problem resetting the password\n$exception');
      }
    } catch (unexpectedException) {
      devtools.log('Unexpected error, $unexpectedException');
    }
  }
}

//Error dialog message function
// void showErrorDialog(BuildContext context, String errorMessage) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         elevation: 3,
//         backgroundColor: Colors.redAccent[100],
//         title: const Center(
//           child: Text('Error'),
//         ),
//         content: Text(
//           errorMessage.toString(),
//           style: const TextStyle(color: Colors.white),
//         ),
//         actions: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text(
//               'Close',
//               style: TextStyle(color: Colors.black),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }
