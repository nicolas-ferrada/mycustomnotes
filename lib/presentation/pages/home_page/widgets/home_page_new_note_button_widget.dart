import 'package:flutter/material.dart';

import '../../../routes/routes.dart';

// Create a new note button
FloatingActionButton newNoteButton(BuildContext context) {
  return FloatingActionButton.extended(
    backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
    label: const Text('New note'),
    icon: const Icon(Icons.create),
    onPressed: () {
      Navigator.pushNamed(context, noteCreatePageRoute);
    },
  );
}
