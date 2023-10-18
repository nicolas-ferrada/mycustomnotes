import 'dart:math';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/domain/services/auth_services.dart/auth_user_service.dart';
import 'package:mycustomnotes/presentation/widgets/privacy_policy_terms_of_service_widget/privacy_policy_terms_of_service_dialog.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';
import 'package:path/path.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../l10n/l10n_export.dart';

import 'dart:developer' as log;

class AuthUserServiceAppleSignIn {
  static Future<void> logInApple(context) async {
    try {
      log.log('1');
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      log.log('2');
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      log.log('3');
      final user =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      log.log('4');
      log.log('user email ${user.user!.email.toString()}');
      log.log('apple email ${appleCredential.email.toString()}');
      log.log('user credential ${appleCredential.email.toString()}');
      log.log(
          'current user ${FirebaseAuth.instance.currentUser!.uid.toString()}');
    } catch (e) {
      throw Exception(e).removeExceptionWord;
    }
  }

  // static Future<UserCredential?> reAuthUserApple({
  //   required String email,
  //   required BuildContext context,
  // }) async {
  //   try {
  //     User currentUser = AuthUserService.getCurrentUser();

  //     final GoogleSignInAccount? googleUser =
  //         await GoogleSignIn().signInSilently();

  //     if (googleUser == null) return null;

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     UserCredential reAuthedUser =
  //         await currentUser.reauthenticateWithCredential(
  //       GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       ),
  //     );
  //     return reAuthedUser;
  //   } on FirebaseAuthException catch (firebaseException) {
  //     if (!context.mounted) return null;
  //     if (firebaseException.code == 'user-mismatch') {
  //       throw Exception(AppLocalizations.of(context)!
  //               .changeEmailUserMismatch_exception_myAccountWidgetChangeEmailPageException)
  //           .removeExceptionWord;
  //     } else if (firebaseException.code == 'user-not-found') {
  //       throw Exception(AppLocalizations.of(context)!
  //               .changeEmailUserNotFound_exception_myAccountWidgetChangeEmailPageException)
  //           .removeExceptionWord;
  //     } else if (firebaseException.code == 'invalid-credential') {
  //       throw Exception(AppLocalizations.of(context)!
  //               .changeEmailInvalidCredentials_exception_myAccountWidgetChangeEmailPageException)
  //           .removeExceptionWord;
  //     } else if (firebaseException.code == 'invalid-email') {
  //       throw Exception(AppLocalizations.of(context)!
  //               .changeEmailInvalidEmail_exception_myAccountWidgetChangeEmailPageException)
  //           .removeExceptionWord;
  //     } else if (firebaseException.code == 'wrong-password') {
  //       throw Exception(AppLocalizations.of(context)!
  //               .changeEmailWrongPassword_exception_myAccountWidgetChangeEmailPageException)
  //           .removeExceptionWord;
  //     } else {
  //       throw Exception(AppLocalizations.of(context)!
  //               .changeEmailGeneric_exception_myAccountWidgetChangeEmailPageException)
  //           .removeExceptionWord;
  //     }
  //   } catch (unexpectedException) {
  //     if (!context.mounted) return null;
  //     throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
  //         .removeExceptionWord;
  //   }
  // }
}
