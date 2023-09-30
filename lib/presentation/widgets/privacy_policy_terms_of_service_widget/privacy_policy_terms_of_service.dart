import 'package:flutter/material.dart';
import 'package:mycustomnotes/l10n/l10n_export.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PrivacyPolicyTermsOfServiceWidget extends StatefulWidget {
  bool isUserAccepting;
  Function updateUserAcceptance;
  PrivacyPolicyTermsOfServiceWidget({
    super.key,
    required this.isUserAccepting,
    required this.updateUserAcceptance,
  });

  @override
  State<PrivacyPolicyTermsOfServiceWidget> createState() =>
      _PrivacyPolicyTermsOfServiceWidgetState();
}

class _PrivacyPolicyTermsOfServiceWidgetState
    extends State<PrivacyPolicyTermsOfServiceWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Transform.scale(
            scale: 1.5,
            child: SizedBox(
              width: 38,
              height: 28,
              child: Checkbox(
                // visualDensity: VisualDensity.compact,
                value: widget.isUserAccepting,
                onChanged: (value) {
                  setState(() {
                    widget.updateUserAcceptance(value!);
                  });
                },
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.agree_text_pptos,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            AppLocalizations.of(context)!.the_text_pptos,
            style: const TextStyle(fontSize: 14),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => {
              launchUrl(
                Uri.parse(
                    'https://mycustomnotes.nicolasferrada.com/privacy-policy'),
              ),
            },
            child: Text(
              AppLocalizations.of(context)!.privacyPolicy_text_pptos,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 16,
                fontStyle: FontStyle.italic,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.and_text_pptos,
            style: const TextStyle(fontSize: 14),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => {
              launchUrl(
                Uri.parse(
                    'https://mycustomnotes.nicolasferrada.com/terms-of-service'),
              ),
            },
            child: Text(
              AppLocalizations.of(context)!.termsOfService_text_pptos,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 16,
                fontStyle: FontStyle.italic,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
