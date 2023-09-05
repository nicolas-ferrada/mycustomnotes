import 'package:firebase_auth/firebase_auth.dart' show User, UserCredential;
import 'package:flutter/material.dart';
import 'package:mycustomnotes/domain/services/auth_services.dart/auth_user_service_email_password.dart';
import 'package:mycustomnotes/domain/services/auth_services.dart/auth_user_service_google_singin.dart';
import 'package:mycustomnotes/l10n/l10n_export.dart';
import 'package:mycustomnotes/utils/enums/user_auth_provider.dart';

import '../../../domain/services/auth_services.dart/auth_user_service.dart';
import '../../../utils/app_color_scheme/app_color_scheme.dart';
import '../../../utils/dialogs/successful_message_dialog.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';

class ChangeEmailPage extends StatefulWidget {
  final User currentUser;
  final UserAuthProvider userAuthProvider;
  const ChangeEmailPage({
    super.key,
    required this.currentUser,
    required this.userAuthProvider,
  });

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _passwordLoginController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _confirmNewEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!
            .changeEmailTitle_text_myAccountWidgetChangeEmailPage),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              providerWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget providerWidget() {
    if (widget.userAuthProvider == UserAuthProvider.emailPassword) {
      return emailPasswordProviderWidget(context);
    } else if (widget.userAuthProvider == UserAuthProvider.google ||
        widget.userAuthProvider == UserAuthProvider.emailPasswordAndGoogle) {
      return googleProviderWidget(context);
    } else {
      return const Text('Error: No provider found');
    }
  }

  Widget emailPasswordProviderWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            AppLocalizations.of(context)!
                .changeEmailSubtitle_text_myAccountWidgetChangeEmailPage,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        // Password input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: _passwordLoginController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!
                  .changeEmailCurrentPasswordInput_textformfield_myAccountWidgetChangeEmailPage,
              prefixIcon: const Icon(Icons.lock),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColorScheme.purple(),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        // New email
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: _newEmailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!
                  .changeEmailEmailInput_textformfield_myAccountWidgetChangeEmailPage,
              prefixIcon: const Icon(Icons.mail),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColorScheme.purple(),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
          ),
        ),
        // Confirm new email
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: _confirmNewEmailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!
                  .changeEmailEmailInputConfirm_textformfield_myAccountWidgetChangeEmailPage,
              prefixIcon: const Icon(Icons.mail),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColorScheme.purple(),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        // Confirm button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 10,
            minimumSize: const Size(200, 60),
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            changeEmailInEmailPassword();
          },
          child: Text(
            AppLocalizations.of(context)!
                .changeEmailTitle_text_myAccountWidgetChangeEmailPage,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget googleProviderWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            AppLocalizations.of(context)!
                .changeEmailSubtitle_text_myAccountWidgetChangeEmailPage,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        Visibility(
          visible: (widget.userAuthProvider ==
              UserAuthProvider.emailPasswordAndGoogle),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  AppLocalizations.of(context)!
                      .emailPasswordAndGoogleProvider_text_myAccountWidget,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  AppLocalizations.of(context)!
                      .changeEmailMultiprovider_text_myAccountWidgetChangeEmailPage,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        // New email
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: _newEmailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!
                  .changeEmailEmailInput_textformfield_myAccountWidgetChangeEmailPage,
              prefixIcon: const Icon(Icons.mail),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColorScheme.purple(),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
          ),
        ),
        // Confirm new email
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextFormField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            controller: _confirmNewEmailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!
                  .changeEmailEmailInputConfirm_textformfield_myAccountWidgetChangeEmailPage,
              prefixIcon: const Icon(Icons.mail),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColorScheme.purple(),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        // Confirm button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 10,
            minimumSize: const Size(200, 60),
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            changeEmailInGoogle();
          },
          child: Text(
            AppLocalizations.of(context)!
                .changeEmailTitle_text_myAccountWidgetChangeEmailPage,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  void changeEmailInEmailPassword() async {
    try {
      if (_passwordLoginController.text.isEmpty) {
        ExceptionsAlertDialog.showErrorDialog(
            context: context,
            errorMessage: AppLocalizations.of(context)!
                .changeEmailNoPassword_exception_myAccountWidgetChangeEmailPageException);
        return;
      }

      if (_newEmailController.text.isEmpty ||
          _confirmNewEmailController.text.isEmpty) {
        ExceptionsAlertDialog.showErrorDialog(
            context: context,
            errorMessage: AppLocalizations.of(context)!
                .changeEmailNoEmails_exception_myAccountWidgetChangeEmailPageException);
        return;
      }

      if (_newEmailController.text != _confirmNewEmailController.text) {
        ExceptionsAlertDialog.showErrorDialog(
            context: context,
            errorMessage: AppLocalizations.of(context)!
                .changeEmailEmailDontMatch_exception_myAccountWidgetChangeEmailPageException);
        return;
      }

      if (_newEmailController.text == widget.currentUser.email!) {
        ExceptionsAlertDialog.showErrorDialog(
            context: context,
            errorMessage: AppLocalizations.of(context)!
                .changeEmailCurrentEmailIsSame_exception_myAccountWidgetChangeEmailPageException);
        return;
      }

      UserCredential reAuthCredentials =
          await AuthUserServiceEmailPassword.reAuthUserEmailPassword(
        context: context,
        email: widget.currentUser.email!,
        password: _passwordLoginController.text,
      );

      if (context.mounted) {
        await AuthUserService.changeEmail(
          updatedUser: reAuthCredentials,
          newEmail: _newEmailController.text,
          context: context,
        ).then(
          (result) {
            if (result != null && result == 'Success') {
              AuthUserService.logOut(context: context);
              Navigator.maybePop(context).then((_) {
                Navigator.maybePop(context).then((_) {
                  return showDialog(
                    context: context,
                    builder: (context) => SuccessfulMessageDialog(
                      sucessMessage: AppLocalizations.of(context)!
                          .changeEmailSucess_dialog_myAccountWidgetChangeEmailPage,
                    ),
                  );
                });
              });
            }
          },
        );
      }
    } catch (errorMessage) {
      ExceptionsAlertDialog.showErrorDialog(
          context: context, errorMessage: errorMessage.toString());
    }
  }

  void changeEmailInGoogle() async {
    try {
      if (_newEmailController.text.isEmpty ||
          _confirmNewEmailController.text.isEmpty) {
        ExceptionsAlertDialog.showErrorDialog(
            context: context,
            errorMessage: AppLocalizations.of(context)!
                .changeEmailNoEmails_exception_myAccountWidgetChangeEmailPageException);
        return;
      }

      if (_newEmailController.text != _confirmNewEmailController.text) {
        ExceptionsAlertDialog.showErrorDialog(
            context: context,
            errorMessage: AppLocalizations.of(context)!
                .changeEmailEmailDontMatch_exception_myAccountWidgetChangeEmailPageException);
        return;
      }

      if (_newEmailController.text == widget.currentUser.email!) {
        ExceptionsAlertDialog.showErrorDialog(
            context: context,
            errorMessage: AppLocalizations.of(context)!
                .changeEmailCurrentEmailIsSame_exception_myAccountWidgetChangeEmailPageException);
        return;
      }

      UserCredential? reAuthCredentials =
          await AuthUserServiceGoogleSignIn.reAuthUserGoogle(
        context: context,
        email: widget.currentUser.email!,
      );

      if (context.mounted && reAuthCredentials != null) {
        await AuthUserService.changeEmail(
          updatedUser: reAuthCredentials,
          newEmail: _newEmailController.text,
          context: context,
        ).then(
          (result) {
            if (result != null && result == 'Success') {
              AuthUserService.logOut(context: context);
              Navigator.maybePop(context).then((_) {
                Navigator.maybePop(context).then((_) {
                  return showDialog(
                    context: context,
                    builder: (context) => SuccessfulMessageDialog(
                      sucessMessage: AppLocalizations.of(context)!
                          .changeEmailSucess_dialog_myAccountWidgetChangeEmailPage,
                    ),
                  );
                });
              });
            }
          },
        );
      }
    } catch (errorMessage) {
      ExceptionsAlertDialog.showErrorDialog(
          context: context, errorMessage: errorMessage.toString());
    }
  }
}
