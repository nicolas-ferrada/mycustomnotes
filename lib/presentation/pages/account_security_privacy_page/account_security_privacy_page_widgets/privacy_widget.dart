import 'package:flutter/material.dart';

import '../../../../l10n/l10n_export.dart';

class PrivacyWidget extends StatefulWidget {
  const PrivacyWidget({super.key});

  @override
  State<PrivacyWidget> createState() => _PrivacyWidgetState();
}

class _PrivacyWidgetState extends State<PrivacyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        privacyTitle(),
        Text('Delete my account'),
        Text('Export my data'),
        Text('Terms of service and Privacy policies'),
      ],
    );
  }

  Widget privacyTitle() {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.privacyTitle_text_accountSecurityPrivacy,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}
