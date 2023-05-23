import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:mycustomnotes/data/models/User/user_configuration.dart';
import '../../../../data/models/Note/note_tasks_model.dart';
import '../../../../domain/services/note_tasks_service.dart';
import '../../../../data/models/Note/note_text_model.dart';
import '../../../../l10n/l10n_export.dart';
import 'home_page_build_notes_widget.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/Note/note_notifier.dart';
import '../../../../domain/services/note_text_service.dart';

class ReadNotesStreamConsumer extends StatelessWidget {
  final User currentUser;
  final UserConfiguration userConfiguration;
  const ReadNotesStreamConsumer({
    super.key,
    required this.currentUser,
    required this.userConfiguration,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteNotifier>(builder: (context, noteNotifier, _) {
      return StreamBuilder(
        stream: NoteTasksService.readAllNotesTasks(
            userId: currentUser.uid, context: context),
        builder: (context, snapshotNoteTasks) {
          if (snapshotNoteTasks.hasError) {
            return Text(AppLocalizations.of(context)!
                .getNotesError_snapshotHasError_homePage);
          } else {
            return StreamBuilder(
              stream: NoteTextService.readAllNotesText(
                  userId: currentUser.uid, context: context),
              builder: (context, snapshotNoteText) {
                if (snapshotNoteText.hasError) {
                  return Text(AppLocalizations.of(context)!
                      .getNotesError_snapshotHasError_homePage);
                } else if (snapshotNoteText.hasData &&
                    snapshotNoteTasks.hasData) {
                  final List<NoteText> textNotes = snapshotNoteText.data!;
                  final List<NoteTasks> tasksNotes = snapshotNoteTasks.data!;
                  return textNotes.isEmpty && tasksNotes.isEmpty
                      ? Center(
                          child: Text(AppLocalizations.of(context)!
                              .noNotesCreated_text_homePage))
                      : HomePageBuildNotesWidget(
                          notesTextList: textNotes,
                          notesTasksList: tasksNotes,
                          userConfiguration: userConfiguration,
                        );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          }
        },
      );
    });
  }
}
