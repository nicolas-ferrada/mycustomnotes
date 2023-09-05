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
          AppLocalizations.of(context)!
              .changePasswordTitle_text_myAccountWidgetChangePasswordPage,
        ),
        centerTitle: true,
      ),
      body: selectChangePasswordWidget(),
    );
  }

  Widget selectChangePasswordWidget() {
    if (widget.userAuthProvider == UserAuthProvider.emailPassword ||
        widget.userAuthProvider == UserAuthProvider.emailPasswordAndGoogle) {
      return changePasswordWidget(context);
    } else if (widget.userAuthProvider == UserAuthProvider.google) {
      return functionalityNotAvailableForGoogle(context);
    } else {
      return const Text('Error: No provider found');
    }
  }

  Widget functionalityNotAvailableForGoogle(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.googleProvider_text_myAccountWidget),
        const SizedBox(
          height: 8,
        ),
        Text(
          AppLocalizations.of(context)!
              .functionalityNotAvailableForGoogle_text_myAccountWidgetChangePasswordPage,
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }

  Widget changePasswordWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!
                .changePasswordSubtitle_text_myAccountWidgetChangePasswordPage,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            AppLocalizations.of(context)!
                .changePasswordSubtitle2_text_myAccountWidgetChangePasswordPage,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          Visibility(
            visible: (widget.userAuthProvider ==
                UserAuthProvider.emailPasswordAndGoogle),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                AppLocalizations.of(context)!
                    .warningChangingAccountUnlinkGoogle_text_myAccountWidgetChangePasswordPage,
                style: const TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 32,
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
              AppLocalizations.of(context)!
                  .changePasswordTitle_text_myAccountWidgetChangePasswordPage,
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
      ExceptionsAlertDialog.showErrorDialog(
        context: context,
        errorMessage: errorMessage.toString(),
      );
    }
  }
}
