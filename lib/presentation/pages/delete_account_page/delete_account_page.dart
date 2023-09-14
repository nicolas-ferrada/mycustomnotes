import 'dart:async' show Timer;

import 'package:firebase_auth/firebase_auth.dart' show User, UserCredential;
import 'package:flutter/material.dart';
import 'package:mycustomnotes/domain/services/auth_services.dart/auth_user_service.dart';
import 'package:mycustomnotes/domain/services/auth_services.dart/auth_user_service_google_singin.dart';
import 'package:mycustomnotes/l10n/l10n_export.dart';
import 'package:mycustomnotes/utils/dialogs/successful_message_dialog.dart';
import 'package:mycustomnotes/utils/enums/user_auth_provider.dart';

import '../../../domain/services/auth_services.dart/auth_user_service_email_password.dart';
import '../../../utils/app_color_scheme/app_color_scheme.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';

class DeleteAccountPage extends StatefulWidget {
  final User currentUser;
  final UserAuthProvider userAuthProvider;
  const DeleteAccountPage({
    super.key,
    required this.currentUser,
    required this.userAuthProvider,
  });

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  Timer? timerToDeleteAccount;
  static const timerDuration = 15;
  int seconds = timerDuration;
  bool didUserPressDeleteAccountButton = false;

  final _passwordLoginController = TextEditingController();

  @override
  void dispose() {
    _passwordLoginController.dispose();
    timerToDeleteAccount?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Privacy widget page will get this var on leaving and it'll show a dialog if it was true
        Navigator.pop(context, didUserPressDeleteAccountButton);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!
              .deleteAccountTitle_text_privacyWidgetDeleteAccountPage),
          centerTitle: true,
        ),
        body: providerWidget(),
      ),
    );
  }

  Widget providerWidget() {
    if (widget.userAuthProvider == UserAuthProvider.emailPassword) {
      return deleteAccountEmailPassword(context);
    } else if (widget.userAuthProvider == UserAuthProvider.google ||
        widget.userAuthProvider == UserAuthProvider.emailPasswordAndGoogle) {
      return deleteAccountGoogle(context);
    } else {
      return const Text('Error: No provider found');
    }
  }

  Widget deleteAccountEmailPassword(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: !didUserPressDeleteAccountButton,
                child: Text(
                  AppLocalizations.of(context)!
                      .deleteAccountSubtitle_text_privacyWidgetDeleteAccountPage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Visibility(
                visible: !didUserPressDeleteAccountButton,
                child: Text(
                  AppLocalizations.of(context)!
                      .deleteAccountSubtitle2_text_privacyWidgetDeleteAccountPage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(
                height: didUserPressDeleteAccountButton ? 0 : 32,
              ),
              Visibility(
                visible: !didUserPressDeleteAccountButton,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        borderSide: BorderSide(color: AppColorScheme.purple()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: didUserPressDeleteAccountButton ? 0 : 32,
              ),
              buttonAndTimerWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget deleteAccountGoogle(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: !didUserPressDeleteAccountButton,
                child: Text(
                  AppLocalizations.of(context)!
                      .deleteAccountSubtitle_text_privacyWidgetDeleteAccountPage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Visibility(
                visible: !didUserPressDeleteAccountButton,
                child: Text(
                  AppLocalizations.of(context)!
                      .deleteAccountSubtitle2_text_privacyWidgetDeleteAccountPage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(
                height: didUserPressDeleteAccountButton ? 0 : 32,
              ),
              buttonAndTimerWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonAndTimerWidget() {
    return Center(
      child: Stack(
        children: [
          // Delete account button
          Visibility(
            visible: !didUserPressDeleteAccountButton,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                minimumSize: const Size(200, 60),
                backgroundColor: Colors.white,
              ),
              onPressed: () async {
                try {
                  if (widget.userAuthProvider ==
                      UserAuthProvider.emailPassword) {
                    if (_passwordLoginController.text.isEmpty) {
                      ExceptionsAlertDialog.showErrorDialog(
                          context: context,
                          errorMessage: AppLocalizations.of(context)!
                              .changeEmailNoPassword_exception_myAccountWidgetChangeEmailPageException);
                      return;
                    }
                    await AuthUserServiceEmailPassword.reAuthUserEmailPassword(
                      context: context,
                      email: widget.currentUser.email!,
                      password: _passwordLoginController.text,
                    ).then((reAuthCredentials) {
                      setState(() {
                        didUserPressDeleteAccountButton = true;
                      });
                      startDeleteCountdown(
                          reAuthCredentials: reAuthCredentials);
                    });
                  } else {
                    await AuthUserServiceGoogleSignIn.reAuthUserGoogle(
                      context: context,
                      email: widget.currentUser.email!,
                    ).then((reAuthCredentials) {
                      setState(() {
                        didUserPressDeleteAccountButton = true;
                      });
                      if (reAuthCredentials != null) {
                        startDeleteCountdown(
                            reAuthCredentials: reAuthCredentials);
                      } else {
                        throw Exception(AppLocalizations.of(context)!
                            .unexpectedException_dialog);
                      }
                    });
                  }
                } catch (errorMessage) {
                  if (!context.mounted) return;

                  ExceptionsAlertDialog.showErrorDialog(
                      context: context, errorMessage: errorMessage.toString());
                }
              },
              child: Text(
                AppLocalizations.of(context)!
                    .deleteAccountTitle_text_privacyWidgetDeleteAccountPage,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Stack(
            children: [
              // Delete account countdown, this widget will be shown only after user pressed the
              // delete account button and it will dissapear after the timer ends
              Visibility(
                visible: (didUserPressDeleteAccountButton && seconds > 0),
                child: deleteCountdownWidget(),
              ),
              // This widget is visible only while the account is being deleted (after timer is 0)
              Visibility(
                visible: (didUserPressDeleteAccountButton && seconds <= 0),
                child: accountBeingDeletedWidget(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void startDeleteCountdown({
    required UserCredential reAuthCredentials,
  }) {
    timerToDeleteAccount = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (seconds > 0) {
          setState(() => seconds--);
        }
        // Timer reached zero
        else {
          timerToDeleteAccount!.cancel();
          deleteAccount(reAuthCredentials: reAuthCredentials);
        }
      },
    );
  }

  Widget deleteCountdownWidget() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!
              .deleteAccountCountdownText_text_privacyWidgetDeleteAccountPage(
                  seconds),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        // Cancel cowndown
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 10,
            minimumSize: const Size(260, 70),
            backgroundColor: Colors.redAccent,
          ),
          onPressed: () async {
            setState(() {
              didUserPressDeleteAccountButton = false;
            });
            Navigator.maybePop(context).then(
              (value) => showDialog(
                context: context,
                builder: (context) => SuccessfulMessageDialog(
                  sucessMessage: AppLocalizations.of(context)!
                      .deleteAccountCountdownCanceled_text_privacyWidgetDeleteAccountPage,
                ),
              ),
            );
          },
          child: Text(
            AppLocalizations.of(context)!
                .deleteAccountCancelCountdown_button_privacyWidgetDeleteAccountPage,
            textAlign: TextAlign.center,
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

  Widget accountBeingDeletedWidget() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!
              .deleteAccountDeleteInProgress_text_privacyWidgetDeleteAccountPage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Timer reached zero, so account is getting deleted
  void deleteAccount({
    required UserCredential reAuthCredentials,
  }) async {
    try {
      if (context.mounted) {
        await AuthUserService.deleteAccount(
          context: context,
          updatedUser: reAuthCredentials,
        ).then(
          (result) {
            if (result != null && result == 'Success') {
              AuthUserService.logOut(context: context);
              Navigator.pop(context);
              Navigator.pop(context);
              return showDialog(
                context: context,
                builder: (context) => SuccessfulMessageDialog(
                  sucessMessage: AppLocalizations.of(context)!
                      .deleteAccountYourAccountWasDeleted_text_privacyWidgetDeleteAccountPage,
                ),
              );
            }
          },
        );
      }
    } catch (errorMessage) {
      if (!context.mounted) return;

      ExceptionsAlertDialog.showErrorDialog(
          context: context, errorMessage: errorMessage.toString());
    }
  }
}
