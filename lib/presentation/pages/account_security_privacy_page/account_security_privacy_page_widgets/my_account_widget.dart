import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

import '../../../../l10n/l10n_export.dart';

class MyAccountWidget extends StatefulWidget {
  final User currentUser;
  const MyAccountWidget({
    super.key,
    required this.currentUser,
  });

  @override
  State<MyAccountWidget> createState() => _MyAccountWidgetState();
}

class _MyAccountWidgetState extends State<MyAccountWidget> {
  bool isEmailCensored = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          myAccountTitle(),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade800.withOpacity(1),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  showEmail(),
                  showProvider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myAccountTitle() {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.accountTitle_text_accountSecurityPrivacy,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget showEmail() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.email, size: 18),
              const SizedBox(
                width: 4,
              ),
              Text(
                AppLocalizations.of(context)!
                    .myEmailSubtitle_text_myAccountWidget,
                style: const TextStyle(fontSize: 15),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isEmailCensored = !isEmailCensored;
                      });
                    },
                    child: Icon(
                      isEmailCensored ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          widget.currentUser.email != null
              ? isEmailCensored
                  ? const Text(
                      '*************************',
                      style: TextStyle(fontSize: 20),
                    )
                  : Text(
                      widget.currentUser.email!,
                      style: const TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    )
              : Text(AppLocalizations.of(context)!
                  .showEmailException_text_myAccountWidget)
        ],
      ),
    );
  }

  Widget showProvider() {
    String userProvider = '';
    for (final provider in widget.currentUser.providerData) {
      userProvider = provider.providerId;
    }
    if (userProvider == 'password') {
      return Text(
        AppLocalizations.of(context)!.passwordProvider_text_myAccountWidget,
        style: const TextStyle(fontSize: 10),
      );
    } else if (userProvider == 'google.com') {
      return Text(
        AppLocalizations.of(context)!.googleProvider_text_myAccountWidget,
        style: const TextStyle(fontSize: 10),
      );
    } else {
      return Text(
        AppLocalizations.of(context)!.providerNotFound_text_myAccountWidget,
        style: const TextStyle(fontSize: 10),
      );
    }
  }
}
