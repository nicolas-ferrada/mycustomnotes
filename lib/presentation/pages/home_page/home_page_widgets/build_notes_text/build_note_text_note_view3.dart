import 'package:flutter/material.dart';

import '../../../../../data/models/Note/note_text_model.dart';
import '../../../../../utils/formatters/date_formatter.dart';
import '../../../../../utils/note_color/note_color.dart';

class NoteTextView3Large extends StatelessWidget {
  final NoteText note;
  const NoteTextView3Large({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      // Color of the note
      color: NoteColorOperations.getColorFromNumber(colorNumber: note.color),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top of the note card
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
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600),
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
            Text(
              note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Text body
            Text(
              note.body,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
