import 'package:flutter/material.dart';
import 'package:mycustomnotes/l10n/l10n_export.dart';
import 'package:mycustomnotes/presentation/widgets/privacy_policy_terms_of_service_widget/privacy_policy_terms_of_service.dart';
import 'package:mycustomnotes/utils/styles/dialog_subtitle_style.dart';
import 'package:mycustomnotes/utils/styles/dialog_title_style.dart';

class PrivacyPolicyTermsOfServiceDialog extends StatefulWidget {
  const PrivacyPolicyTermsOfServiceDialog({super.key});

  @override
  State<PrivacyPolicyTermsOfServiceDialog> createState() =>
      _PrivacyPolicyTermsOfServiceDialogState();
}

class _PrivacyPolicyTermsOfServiceDialogState
    extends State<PrivacyPolicyTermsOfServiceDialog> {
  bool isUserAcceptingPPAndTos = false;

  bool shouldPop = false;

  void updateUserAcceptance(bool newValue) {
    setState(() {
      isUserAcceptingPPAndTos = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (shouldPop) {
          // Allow the back button to pop the route only after 'continue button' is pressed
          return true;
        } else {
          return false;
        }
      },
      child: AlertDialog(
        elevation: 3,
        backgroundColor: Colors.grey,
        title: Center(
          child: DialogTitleStyle(
            title: AppLocalizations.of(context)!.title_text_pptos,
            fontSize: 24,
          ),
        ),
        content: DialogSubtitleStyle(
          widget: PrivacyPolicyTermsOfServiceWidget(
            isUserAccepting: isUserAcceptingPPAndTos,
            updateUserAcceptance: updateUserAcceptance,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              shouldPop = true;
              didUserAcceptedPPAndTos();
            },
            child: Text(
              AppLocalizations.of(context)!.continueButton,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void didUserAcceptedPPAndTos() {
    if (isUserAcceptingPPAndTos == true) {
      Navigator.maybePop(context, true);
    } else {
      Navigator.maybePop(context, false);
    }
  }
}
