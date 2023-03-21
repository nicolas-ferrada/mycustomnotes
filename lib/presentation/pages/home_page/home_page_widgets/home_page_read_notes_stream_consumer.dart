import 'package:flutter/material.dart';
import '../../../../data/models/Note/note_text_model.dart';
import 'home_page_build_notes_widget.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/Note/note_notifier.dart';
import '../../../../domain/services/auth_user_service.dart';
import '../../../../domain/services/note_text_service.dart';

final currentUser = AuthUserService.getCurrentUserFirebase(); // init state?

Consumer<NoteNotifier> readNotesStreamConsumer() {
  return Consumer<NoteNotifier>(builder: (context, noteNotifier, _) {
    return StreamBuilder(
      stream: NoteTextService.readAllNotesText(userId: currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong ${snapshot.error.toString()}');
        } else if (snapshot.hasData) {
          final List<NoteText> notes = snapshot.data!;
          return Center(
            // If notes are empty, show 'no notes message', if theres notes, build them
            child: notes.isEmpty
                ? const Text('No notes to show')
                : HomePageBuildNotesWidget(
                    notesTextList: notes,
                  ), // Show all notes of the user in screen
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  });
}
