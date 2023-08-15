import 'package:flutter/material.dart';

import '../../l10n/l10n_export.dart';

class SuccessfulMailSentRecoverPasswordDialog extends StatefulWidget {
  final String sucessMessage;
  const SuccessfulMailSentRecoverPasswordDialog({
    super.key,
    required this.sucessMessage,
  });

  @override
  State<SuccessfulMailSentRecoverPasswordDialog> createState() =>
      _SuccessfulMailSentRecoverPasswordDialogState();
}

class _SuccessfulMailSentRecoverPasswordDialogState
    extends State<SuccessfulMailSentRecoverPasswordDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 3,
      backgroundColor: const Color.fromARGB(211, 13, 255, 53),
      title: Center(
        child: Text(
          AppLocalizations.of(context)!
              .sucessfulMailSent_title_dialog_recoverPasswordPage,
        ),
      ),
      content: Text(
        widget.sucessMessage,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          onPressed: () {
            Navigator.maybePop(context);
          },
          child: const Text(
            'Ok',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
