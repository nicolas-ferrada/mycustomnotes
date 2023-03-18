import 'package:flutter/material.dart';

import '../../../../utils/dialogs/confirmation_dialog.dart';

AppBar appBarHomePage({required BuildContext context}) {
  return AppBar(
    centerTitle: true,
    title: const Text(
      'My Custom Notes',
      style: TextStyle(fontSize: 20),
    ),
    actions: [
      IconButton(
        icon: const Icon(
          Icons.settings,
          size: 26,
        ),
        onPressed: () async {
          // User settings
        },
      ),
    ],
    automaticallyImplyLeading: false,
    leading: IconButton(
      icon: Transform.scale(
        scaleX: -1,
        child: const Icon(
          Icons.logout,
          size: 26,
        ),
      ),
      onPressed: () async {
        // Log out dialog
        ConfirmationDialog.logOutDialog(context);
      },
    ),
  );
}
