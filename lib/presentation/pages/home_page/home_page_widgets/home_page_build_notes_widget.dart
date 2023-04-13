import 'package:flutter/material.dart';
import 'package:mycustomnotes/data/models/User/user_configuration.dart';
import 'package:mycustomnotes/presentation/pages/home_page/home_page_widgets/build_notes_tasks/build_note_tasks_note_view1.dart';
import 'package:mycustomnotes/presentation/pages/home_page/home_page_widgets/build_notes_text/build_note_text_note_view1.dart';
import 'package:mycustomnotes/presentation/pages/home_page/home_page_widgets/build_notes_text/build_note_text_note_view2.dart';

import '../../../../data/models/Note/note_tasks_model.dart';
import '../../../../data/models/Note/note_text_model.dart';
import '../../../../utils/extensions/compare_booleans.dart';
import '../../../routes/routes.dart';
import 'build_notes_text/build_note_text_note_view3.dart';

class HomePageBuildNotesWidget extends StatelessWidget {
  final List<NoteText> notesTextList;
  final List<NoteTasks> notesTasksList;
  final UserConfiguration userConfiguration;

  const HomePageBuildNotesWidget({
    required this.notesTextList,
    required this.notesTasksList,
    required this.userConfiguration,
    super.key,
  });

  List<num> selectNoteView() {
    // First option: small notes
    if (userConfiguration.notesView == 1) {
      return [1, 3.5];
    }
    // Second option: double notes
    else if (userConfiguration.notesView == 2) {
      return [2, 1.0];
    }
    // Third option: big notes
    else if (userConfiguration.notesView == 3) {
      return [1, 1.0];
    } else {
      return [1, 2.5];
    }
  }

  @override
  Widget build(BuildContext context) {
    final int amountTotalNotes = notesTextList.length + notesTasksList.length;
    // Build notes structure
    return GridView.custom(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 1,
          crossAxisCount: selectNoteView()[0].toInt(),
          childAspectRatio: selectNoteView()[1].toDouble()),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: amountTotalNotes,
        ((context, index) {
          // Creating a unified list of all notes
          List<dynamic> allNotes = [...notesTextList, ...notesTasksList];
          // Ordered by date, first note created will show first
          allNotes.sort((a, b) => a.createdDate.compareTo(b.createdDate));
          // Put favorites first using a extension boolean compare
          allNotes.sort((a, b) =>
              CompareBooleans.compareBooleans(a.isFavorite, b.isFavorite));

          return GestureDetector(
            // Tapping on a note, opens the detailed version of it
            onTap: () {
              // Check if the tapped note is a NoteText
              if (allNotes[index] is NoteText) {
                NoteText noteText = allNotes[index];
                // Open the detailed version of the NoteText
                Navigator.pushNamed(context, noteTextDetailsPageRoute,
                    arguments: noteText);
              }
              // Check if the tapped note is a NoteTasks
              else if (allNotes[index] is NoteTasks) {
                NoteTasks noteTasks = allNotes[index];
                // Open the detailed version of the NoteTasks
                Navigator.pushNamed(context, noteTasksDetailsPageRoute,
                    arguments: noteTasks);
              }
            },
            // build each note per type/view
            child: whatNoteToShow(
              note: allNotes[index],
              notesViewConfiguration: userConfiguration.notesView,
            ),
          );
        }),
      ),
    );
  }

  whatNoteToShow({
    required dynamic note,
    required int notesViewConfiguration,
  }) {
    // Note text
    if (note is NoteText && notesViewConfiguration == 1) {
      return NoteTextView1Small(note: note);
    } else if (note is NoteText && notesViewConfiguration == 2) {
      return NoteTextView2Split(note: note);
    } else if (note is NoteText && notesViewConfiguration == 3) {
      return NoteTextView3Large(note: note);
    }
    // Note tasks
    else if (note is NoteTasks && notesViewConfiguration == 1) {
      return NoteTasksView1(note: note);
    } else if (note is NoteTasks && notesViewConfiguration == 2) {
    } else if (note is NoteTasks && notesViewConfiguration == 3) {
    } else {
      throw Exception(
          'Something went wrong, that type of Note or Note view does not exists');
    }
  }
}
