import 'package:flutter/material.dart';
import 'package:mycustomnotes/l10n/l10n_export.dart';

import '../../../../utils/dialogs/select_create_note_type.dart';

// Create a new note button
FloatingActionButton newNoteButton({required BuildContext context}) {
  return FloatingActionButton.extended(
    backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
    label: Text(AppLocalizations.of(context)!.newNote_floatingButton_homePage),
    icon: const Icon(Icons.create),
    onPressed: () async {
      SelectCreateNoteType.noteDetailsDialog(context);
    },
  );
}
