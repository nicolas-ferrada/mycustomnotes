import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:mycustomnotes/utils/enums/user_auth_provider.dart';

import '../../../domain/services/auth_services.dart/auth_user_service_email_password.dart';
import '../../../l10n/l10n_export.dart';
import '../../../utils/dialogs/successful_message_dialog.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';

class ChangePasswordPage extends StatefulWidget {
  final User currentUser;
  final UserAuthProvider userAuthProvider;
  const ChangePasswordPage({
    super.key,
    required this.currentUser,
    required this.userAuthProvider,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          changeOrCreate(context),
        ),
        centerTitle: true,
      ),
      body: changePasswordWidget(context),
    );
  }

  String changeOrCreate(BuildContext context) {
    if (widget.userAuthProvider == UserAuthProvider.google) {
      return AppLocalizations.of(context)!
          .createPassword_button_myAccountWidgetChangePasswordPage;
    } else {
      return AppLocalizations.of(context)!
          .changePasswordTitle_text_myAccountWidgetChangePasswordPage;
    }
  }

  String changeOrCreateSubtitle(BuildContext context) {
    if (widget.userAuthProvider == UserAuthProvider.google) {
      return AppLocalizations.of(context)!
          .createPasswordSubtitle_text_myAccountWidgetChangePasswordPage;
    } else {
      return AppLocalizations.of(context)!
          .changePasswordSubtitle_text_myAccountWidgetChangePasswordPage;
    }
  }

  String selectProviderMessage(BuildContext context) {
    if (widget.userAuthProvider == UserAuthProvider.google ||
        widget.userAuthProvider == UserAuthProvider.apple) {
      return AppLocalizations.of(context)!
          .warningChangingAccountUnlinkGoogle2_text_myAccountWidgetChangePasswordPage;
    } else if (widget.userAuthProvider ==
            UserAuthProvider.multipleProvidersWithGoogle ||
        widget.userAuthProvider ==
            UserAuthProvider.multipleProvidersWithApple) {
      return AppLocalizations.of(context)!
          .warningChangingAccountUnlinkGoogle_text_myAccountWidgetChangePasswordPage;
    } else {
      return '';
    }
  }

  Widget changePasswordWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            changeOrCreateSubtitle(context),
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            AppLocalizations.of(context)!
                .changePasswordSubtitle2_text_myAccountWidgetChangePasswordPage,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(
            height: 8,
          ),
          Visibility(
            visible: widget.userAuthProvider == UserAuthProvider.google ||
                widget.userAuthProvider == UserAuthProvider.apple,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                selectProviderMessage(context),
                style: const TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 22,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 10,
              minimumSize: const Size(200, 60),
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              resetPassword();
            },
            child: Text(
              changeOrCreate(context),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetPassword() async {
    try {
      if (widget.currentUser.email != null) {
        await AuthUserServiceEmailPassword.recoverPasswordEmailPassword(
          email: widget.currentUser.email!,
          context: context,
        ).then(
          (_) => Navigator.maybePop(context).then(
            (_) => showDialog(
              context: context,
              builder: (context) => SuccessfulMessageDialog(
                  sucessMessage: AppLocalizations.of(context)!
                      .sucessfulMailSent_body_dialog_recoverPasswordPage),
            ),
          ),
        );
      } else {
        throw Exception(
            AppLocalizations.of(context)!.unexpectedException_dialog);
      }
    } catch (errorMessage) {
      if (!context.mounted) return;

      ExceptionsAlertDialog.showErrorDialog(
        context: context,
        errorMessage: errorMessage.toString(),
      );
    }
  }
}
