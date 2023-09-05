import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/presentation/pages/change_email_page/change_email_page.dart';

import '../../../../l10n/l10n_export.dart';
import '../../../../utils/enums/user_auth_provider.dart';
import '../../change_password_page/change_password_page.dart';

class SecurityWidget extends StatefulWidget {
  final User currentUser;
  final UserAuthProvider userAuthProvider;
  const SecurityWidget({
    super.key,
    required this.currentUser,
    required this.userAuthProvider,
  });

  @override
  State<SecurityWidget> createState() => _SecurityWidgetState();
}

class _SecurityWidgetState extends State<SecurityWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          securityTitle(),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade800.withOpacity(1),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  changeEmail(context),
                  changePassword(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget changePassword(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.password, size: 18),
        const SizedBox(
          width: 4,
        ),
        Text(
          AppLocalizations.of(context)!.changePassword_text_myAccountWidget,
          style: const TextStyle(fontSize: 15),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
            text: AppLocalizations.of(context)!
                .changePassword_richText_myAccountWidget,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(
                      currentUser: widget.currentUser,
                      userAuthProvider: widget.userAuthProvider,
                    ),
                  ),
                );
              },
          ),
        ),
      ],
    );
  }

  Widget changeEmail(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.email, size: 18),
        const SizedBox(
          width: 4,
        ),
        Text(
          AppLocalizations.of(context)!
              .emailSubtitleWithSpace_text_myAccountWidget,
          style: const TextStyle(fontSize: 15),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
            text: AppLocalizations.of(context)!
                .changeEmail_richText_myAccountWidget,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeEmailPage(
                      currentUser: widget.currentUser,
                      userAuthProvider: widget.userAuthProvider,
                    ),
                  ),
                );
              },
          ),
        ),
      ],
    );
  }

  Widget securityTitle() {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.securityTitle_text_accountSecurityPrivacy,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}
