import 'package:flutter/material.dart';

import '../../../../l10n/l10n_export.dart';

class SecurityWidget extends StatefulWidget {
  const SecurityWidget({super.key});

  @override
  State<SecurityWidget> createState() => _SecurityWidgetState();
}

class _SecurityWidgetState extends State<SecurityWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        securityTitle(),
        Text('Change email'),
        Text('Change password'),
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
