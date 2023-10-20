import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/domain/services/auth_services.dart/auth_user_service.dart';
import 'package:mycustomnotes/presentation/widgets/privacy_policy_terms_of_service_widget/privacy_policy_terms_of_service_dialog.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../l10n/l10n_export.dart';
import '../../../utils/operations/sha256_of_string.dart';

class AuthUserServiceAppleSignIn {
  static Future<void> logInApple(context) async {
    try {
      final rawNonce = generateNonce();

      /// RawNonce into SHA256
      final nonce = Sha256OfString.sha256ofString(rawNonce);

      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        nonce: Platform.isIOS ? nonce : null,
        scopes: [
          AppleIDAuthorizationScopes.email,
        ],
        webAuthenticationOptions: Platform.isIOS
            ? null
            : WebAuthenticationOptions(
                clientId: 'com.nicolasferrada.mycustomnotes-service',
                redirectUri: Uri.parse(
                    'https://my-custom-notes-sign-in-with-apple.glitch.me/callbacks/sign_in_with_apple'),
              ),
      );

      bool? didUserAccepted = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const PrivacyPolicyTermsOfServiceDialog(),
      );

      if (didUserAccepted == false || didUserAccepted == null) {
        AuthUserService.logOut();
        throw Exception(AppLocalizations.of(context)!
                .pptosWereNotAccepted_exception_pptos)
            .removeExceptionWord;
      }

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: Platform.isIOS ? rawNonce : null,
        accessToken: Platform.isIOS ? null : appleCredential.authorizationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e) {
      // Special exception for canceling sig-in process, don't create a exception popup
      if (e.toString() ==
          "SignInWithAppleAuthorizationError(AuthorizationErrorCode.canceled, The operation couldn’t be completed. (com.apple.AuthenticationServices.AuthorizationError error 1001.))") {
        return;
      } else if (e.toString() ==
          "SignInWithAppleAuthorizationError(AuthorizationErrorCode.canceled, The user closed the Custom Tab)") {
        return;
      }
      throw Exception(e).removeExceptionWord;
    }
  }

  static Future<UserCredential?> reAuthUserApple({
    required String email,
    required BuildContext context,
  }) async {
    try {
      User currentUser = AuthUserService.getCurrentUser();

      final rawNonce = generateNonce();

      /// RawNonce into SHA256
      final nonce = Sha256OfString.sha256ofString(rawNonce);

      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        nonce: Platform.isIOS ? nonce : null,
        scopes: [
          AppleIDAuthorizationScopes.email,
        ],
        webAuthenticationOptions: Platform.isIOS
            ? null
            : WebAuthenticationOptions(
                clientId: 'com.nicolasferrada.mycustomnotes-service',
                redirectUri: Uri.parse(
                    'https://my-custom-notes-sign-in-with-apple.glitch.me/callbacks/sign_in_with_apple'),
              ),
      );

      UserCredential reAuthedUser =
          await currentUser.reauthenticateWithCredential(
        OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: Platform.isIOS ? rawNonce : null,
          accessToken:
              Platform.isIOS ? null : appleCredential.authorizationCode,
        ),
      );
      return reAuthedUser;
    } on FirebaseAuthException catch (firebaseException) {
      if (!context.mounted) return null;
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
      if (!context.mounted) return null;
      throw Exception(AppLocalizations.of(context)!.unexpectedException_dialog)
          .removeExceptionWord;
    }
  }
}
