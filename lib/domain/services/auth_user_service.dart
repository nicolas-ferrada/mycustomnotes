import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/extensions/formatted_message.dart';

class AuthUserService {
  // Register an user with email and password on firebase
  static Future<void> registerUserEmailPasswordFirebase({
    required String email,
    required String password, // Used to register the user, but is not stored
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
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
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Login user firebase
  static Future<void> loginUserFirebase({
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

  // Log out user firebase
  static Future<void> logOutUserFirebase() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
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
          .getMessage;
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
        throw Exception("You have entered an invalid email").getMessage;
      }
      if (firebaseException.code == 'user-not-found') {
        throw Exception("The entered account doesn't exist").getMessage;
      }
      if (firebaseException.code == 'unknown') {
        throw Exception("You have to type an email and password").getMessage;
      } else {
        throw Exception(
                "There is a problem recovering your password:\n$firebaseException")
            .getMessage;
      }
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Get current user logged on firebase
  static User getCurrentUserFirebase() {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return currentUser;
      } else {
        throw Exception("There is no user logged in").getMessage;
      }
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }
}
