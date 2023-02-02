import 'package:firebase_auth/firebase_auth.dart';
import 'package:mycustomnotes/extensions/formatted_message.dart';
import '../database/sqlite/database_helper.dart';
import '../models/user_model.dart';

class AuthUserService {
  // Register user firebase and returns an AuthUser object, if not, throw
  static Future<AuthUser> registerUserFirebase({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential newUser =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return AuthUser(email: email, password: password, id: newUser.user!.uid);
    } on FirebaseAuthException catch (firebaseException) {
      if (firebaseException.code == 'email-already-in-use') {
        throw Exception('You have entered an email that is already in use')
            .getMessage;
      } else if (firebaseException.code == 'invalid-email') {
        throw Exception("You have entered an invalid email").getMessage;
      } else if (firebaseException.code == 'weak-password') {
        throw Exception("You have entered a weak password").getMessage;
      } else if (firebaseException.code == 'unknown') {
        throw Exception("You have to type an email and password").getMessage;
      } else {
        throw Exception(
                "There's a problem in your register process:\n$firebaseException")
            .getMessage;
      }
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException").getMessage;
    }
  }

  // Register user sqlite using the AuthUser object retured by registerUserFirebase.
  static Future registerUserSqlite({
    required AuthUser user,
  }) async {
    try {
      await DatabaseHelper.instance.createUser(user);
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Login user firebase
  static Future loginUserFirebase({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'wrong-password') {
        throw Exception('You have entered a wrong password').getMessage;
      } else if (exception.code == 'user-not-found') {
        throw Exception("The entered account doesn't exist").getMessage;
      } else if (exception.code == 'invalid-email') {
        throw Exception("The entered email is not valid").getMessage;
      } else if (exception.code == 'unknown') {
        throw Exception("You have to type an email and password").getMessage;
      } else if (exception.code == 'network-request-failed') {
        throw Exception("You have to be connected to internet").getMessage;
      } else {
        throw Exception("There is an problem with your login:\n$exception")
            .getMessage;
      }
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Login user sqlite (not used)
  static Future<void> loginUserSqlite({
    required String email,
    required String password,
  }) async {
    try {
      await DatabaseHelper.instance.loginUser(email, password);
    } catch (unexpectedException) {
      throw Exception(
              "There is an unexpected error with the local login:\n$unexpectedException")
          .getMessage;
    }
  }

  // Log out user firebase
  static Future logOutUserFirebase() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException").getMessage;
    }
  }

  // Log out user Sqlite
  // Close db?

  // Email verification user firebase
  static Future emailVerificationUserFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException").getMessage;
    }
  }

  // Email verification user sqlite
  // Needed? save it after?

  // Recover password user firebase
  static Future recoverPasswordUserFirebase({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (firebaseException) {
      if (firebaseException.code == 'invalid-email') {
        throw Exception("You have entered an invalid email").getMessage;
      }
      if (firebaseException.code == 'user-not-found') {
        throw Exception("The entered account doesn't exist").getMessage;
      }
      if (firebaseException.code == 'unknown') {
        throw Exception("You have to type an email and password").getMessage;
      } else {
        throw Exception(
            "There is a problem recovering your password:\n$firebaseException").getMessage;
      }
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException").getMessage;
    }
  }

  // Recover user password sqlite
  // needed? need to change the password aswell?
}
