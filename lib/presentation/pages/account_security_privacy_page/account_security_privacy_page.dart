import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:mycustomnotes/presentation/pages/account_security_privacy_page/account_security_privacy_page_widgets/privacy_widget.dart';
import '../../../l10n/l10n_export.dart';
import 'account_security_privacy_page_widgets/my_account_widget.dart';
import 'account_security_privacy_page_widgets/security_widget.dart';

class AccountSecurityPrivacyPage extends StatefulWidget {
  final User currentUser;
  const AccountSecurityPrivacyPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<AccountSecurityPrivacyPage> createState() =>
      _AccountSecurityPrivacyPageState();
}

class _AccountSecurityPrivacyPageState
    extends State<AccountSecurityPrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.emailSubtitle_text_myAccountWidget,
          style: const TextStyle(fontSize: 17),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: MyAccountWidget(currentUser: widget.currentUser)),
          const Expanded(child: SecurityWidget()),
          const Expanded(child: PrivacyWidget()),
        ],
      ),
    );
  }
}
