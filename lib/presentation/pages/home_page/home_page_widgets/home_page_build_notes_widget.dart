import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mycustomnotes/data/models/User/user_configuration.dart';
import 'package:mycustomnotes/presentation/pages/home_page/home_page_widgets/build_notes_types/build_note_tasks_note_view1.dart';
import 'package:mycustomnotes/presentation/pages/home_page/home_page_widgets/build_notes_types/build_note_text_note_view1.dart';
import 'package:mycustomnotes/presentation/pages/home_page/home_page_widgets/build_notes_types/build_note_text_note_view2.dart';

import '../../../../data/models/Note/note_tasks_model.dart';
import '../../../../data/models/Note/note_text_model.dart';
import '../../../../utils/extensions/compare_booleans.dart';
import '../../../../utils/formatters/date_formatter.dart';
import '../../../../utils/note_color/note_color.dart';
import '../../../routes/routes.dart';

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

  @override
  Widget build(BuildContext context) {
    final int amountTotalNotes = notesTextList.length + notesTasksList.length;

    // Build the notes
    return GridView.custom(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: userConfiguration.notesView,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: amountTotalNotes,
        ((context, index) {
          // // Ordered by date, first note created will show first
          // notesTextList.sort((a, b) => a.createdDate.compareTo(b.createdDate));
          // // Put favorites first using a extension boolean compare
          // notesTextList.sort((a, b) =>
          //     CompareBooleans.compareBooleans(a.isFavorite, b.isFavorite));
          // // Same with tasks notes
          // notesTasksList.sort((a, b) => a.createdDate.compareTo(b.createdDate));
          // notesTasksList.sort((a, b) =>
          //     CompareBooleans.compareBooleans(a.isFavorite, b.isFavorite));

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
      return NoteTextView1(note: note);
    } else if (note is NoteText && notesViewConfiguration == 2) {
      return NoteTextView2(note: note);
    } else if (note is NoteText && notesViewConfiguration == 3) {
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

  // Show the notes cards in home screen
  Card showNotes({
    required dynamic note,
    required int notesViewConfiguration,
  }) {
    // Note is a Text Note
    if (note is NoteText) {
      return Card(
        // Color of the note
        color: NoteColorOperations.getColorFromNumber(colorNumber: note.color),
        child: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        // Date of last modification
                        DateFormatter.showDateFormatted(
                            note.lastModificationDate),
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: Icon(
                        Icons.text_snippet,
                        color: NoteColorOperations.getColorFromNumber(
                            colorNumber: note.color),
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: note.isFavorite
                          ? Stack(
                              children: const [
                                Icon(
                                  Icons.star,
                                  color: Color.fromARGB(255, 255, 255, 0),
                                  size: 26,
                                ),
                                Icon(
                                  Icons.star_border,
                                  color: Colors.black,
                                  size: 26,
                                ),
                              ],
                            )
                          : const Opacity(
                              opacity: 0,
                              child: Icon(
                                Icons.star,
                                size: 26,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Text title
              Center(
                child: Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              // Text body
              Center(
                child: Text(
                  note.body,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      // The note tapped is a Note Tasks
    } else if (note is NoteTasks) {
      return Card(
        // Color of the note
        color: NoteColorOperations.getColorFromNumber(colorNumber: note.color),
        child: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        // Date of last modification
                        DateFormatter.showDateFormatted(
                            note.lastModificationDate),
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: Icon(
                        Icons.view_list,
                        color: NoteColorOperations.getColorFromNumber(
                            colorNumber: note.color),
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: note.isFavorite
                          ? Stack(
                              children: const [
                                Icon(
                                  Icons.star,
                                  color: Color.fromARGB(255, 255, 255, 0),
                                  size: 26,
                                ),
                                Icon(
                                  Icons.star_border,
                                  color: Colors.black,
                                  size: 26,
                                ),
                              ],
                            )
                          : const Opacity(
                              opacity: 0,
                              child: Icon(
                                Icons.star,
                                size: 26,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Text title
              Center(
                child: Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        min((note.tasks.length < 4 ? note.tasks.length : 4), 4),
                    itemBuilder: (context, index) {
                      Map<String, dynamic> task = note.tasks[index];
                      String taskName = task['taskName'];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              taskName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    } else {
      throw Exception('That type of note does not exist');
    }
  }
}
