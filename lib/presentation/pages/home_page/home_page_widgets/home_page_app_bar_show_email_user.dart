import 'package:flutter/material.dart';

import '../../../../domain/services/auth_user_service.dart';
import '../../../../utils/dialogs/confirmation_dialog.dart';

final currentUser = AuthUserService.getCurrentUserFirebase(); // init state?

AppBar appBarShowEmailUser({required BuildContext context}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      '${currentUser.email}',
      style: const TextStyle(fontSize: 16),
    ),
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
