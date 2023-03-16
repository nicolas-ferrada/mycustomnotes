import 'package:flutter/material.dart';
import 'home_page_build_notes_widget.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/Note/note_model.dart';
import '../../../../data/models/Note/note_notifier.dart';
import '../../../../domain/services/auth_user_service.dart';
import '../../../../domain/services/note_service.dart';


final currentUser = AuthUserService.getCurrentUserFirebase(); // init state?

Consumer<NoteNotifier> readNotesStreamConsumer() {
  return Consumer<NoteNotifier>(builder: (context, noteNotifier, _) {
    return StreamBuilder(
      stream: NoteService.readAllNotes(userId: currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong ${snapshot.error.toString()}');
        } else if (snapshot.hasData) {
          final List<Note> notes = snapshot.data!;
          return Center(
            // If notes are empty, show 'no notes message', if theres notes, build them
            child: notes.isEmpty
                ? const Text('No notes to show')
                : HomePageBuildNotesWidget(
                    notesList: notes,
                  ), // Show all notes of the user in screen
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  });
}
