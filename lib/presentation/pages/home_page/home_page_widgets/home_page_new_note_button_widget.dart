import 'package:flutter/material.dart';

import '../../../../utils/dialogs/select_create_note_type.dart';

// Create a new note button
FloatingActionButton newNoteButton({required BuildContext context}) {
  return FloatingActionButton.extended(
    backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
    label: const Text('New note'),
    icon: const Icon(Icons.create),
    onPressed: () {
      SelectCreateNoteType.noteDetailsDialog(context);
    },
  );
}
