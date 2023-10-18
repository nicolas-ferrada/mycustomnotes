import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../l10n/l10n_export.dart';
import '../../../utils/enums/user_auth_provider.dart';
import '../../../utils/extensions/formatted_message.dart';

class AuthUserService {
  static Future<void> logOut({
    BuildContext? context,
  }) async {
    try {
      // If user uses both providers, if they log in with email and password instead of google,
      // this will throw an exception and won't let them close session, that's why ignore
      GoogleSignIn().disconnect().ignore();

      await FirebaseAuth.instance.signOut();
      await FirebaseFirestore.instance.terminate();
      await FirebaseFirestore.instance.clearPersistence();
    } catch (unexpectedException) {
      if (context != null) {
        if (!context.mounted) return;
        throw Exception(
                AppLocalizations.of(context)!.unexpectedException_dialog)
            .removeExceptionWord;
      }
    }
  }

  static User getCurrentUser() {
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

  static UserAuthProvider getUserAuthProvider({
    required User currentUser,
    required BuildContext context,
  }) {
    try {
      List<String> userProviderList = [];
      late UserAuthProvider finalUserAuthProvider;
      for (final provider in currentUser.providerData) {
        userProviderList.add(provider.providerId);
      }
      if (userProviderList.contains('password') &&
          userProviderList.length == 1) {
        finalUserAuthProvider = UserAuthProvider.emailPassword;
      } else if (userProviderList.contains('google.com') &&
          userProviderList.length == 1) {
        finalUserAuthProvider = UserAuthProvider.google;
      } else if (userProviderList.contains('apple.com') &&
          userProviderList.length == 1) {
        finalUserAuthProvider = UserAuthProvider.apple;
      } else {
        finalUserAuthProvider = UserAuthProvider.multipleProviders;
      }
      return finalUserAuthProvider;
    } catch (e) {
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }

  static Future<String?> changeEmail({
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
      if (!context.mounted) throw Exception();
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
      if (!context.mounted) throw Exception();
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }

  static Future<String?> deleteAccount({
    required UserCredential updatedUser,
    required BuildContext context,
  }) async {
    try {
      String operationResult = '';
      final db = FirebaseFirestore.instance;

      // Delete all user firestore documents

      // Delete all note text
      final CollectionReference noteTextCollectionRef =
          db.collection('noteText');

      QuerySnapshot noteTextQuery = await noteTextCollectionRef
          .where('userId', isEqualTo: updatedUser.user!.uid)
          .get();

      for (var doc in noteTextQuery.docs) {
        doc.reference.delete();
      }

      // Delete all note tasks
      final CollectionReference noteTasksCollectionRef =
          db.collection('noteTasks');

      QuerySnapshot noteTasksQuery = await noteTasksCollectionRef
          .where('userId', isEqualTo: updatedUser.user!.uid)
          .get();

      for (var doc in noteTasksQuery.docs) {
        doc.reference.delete();
      }

      // Delete all note folders
      final CollectionReference folderCollectionRef = db.collection('folder');

      QuerySnapshot folderQuery = await folderCollectionRef
          .where('userId', isEqualTo: updatedUser.user!.uid)
          .get();

      for (var doc in folderQuery.docs) {
        doc.reference.delete();
      }

      await updatedUser.user!.delete().then((_) => operationResult = 'Success');
      return operationResult;
    } on FirebaseAuthException catch (firebaseException) {
      if (firebaseException.code == 'requires-recent-login') {
        if (!context.mounted) throw Exception();
        throw Exception(AppLocalizations.of(context)!
                .changeEmailRecentLoginNeeded_exception_myAccountWidgetChangeEmailPageException)
            .removeExceptionWord;
      } else {
        if (!context.mounted) throw Exception();
        throw Exception(AppLocalizations.of(context)!
                .genericDeleteAccountException_dialog_deleteAccountPage)
            .removeExceptionWord;
      }
    } catch (unexpectedException) {
      if (!context.mounted) throw Exception();
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }
}
