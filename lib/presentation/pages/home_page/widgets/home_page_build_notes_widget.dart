import 'package:flutter/material.dart';
import 'package:mycustomnotes/data/models/Note/note_model.dart';
import '../../../../utils/dialogs/pick_note_color.dart';
import '../../../../utils/extensions/compare_booleans.dart';
import '../../../../utils/formatters/date_formatter.dart';
import '../../../routes/routes.dart';

class HomePageBuildNotesWidget extends StatelessWidget {
  final List<Note> notesList;

  const HomePageBuildNotesWidget({
    required this.notesList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Build the notes
    return GridView.custom(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: notesList.length,
        ((context, index) {
          // Ordered by date, first note created will show first
          notesList.sort((a, b) => a.createdDate.compareTo(b.createdDate));
          // Put favorites first using a extension boolean compare
          notesList.sort((a, b) =>
              CompareBooleans.compareBooleans(a.isFavorite, b.isFavorite));
          Note note = notesList[index];
          // Tapping on a note, opens the detailed version of it
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, noteDetailsPageRoute,
                  arguments: note.id);
            },
            child: showNotes(note: note),
          );
        }),
      ),
    );
  }

  // Show the notes
  Card showNotes({required Note note}) {
    return Card(
      // Color of the note
      color: NotesColors.selectNoteColor(note.color),
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    // Date of last modification
                    DateFormatter.showDateFormatted(note.lastModificationDate),
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
  }
}
