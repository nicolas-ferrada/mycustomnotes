import 'package:flutter/material.dart';
import '../../../../../data/models/User/user_configuration.dart';

import '../../../../../data/models/Note/note_text_model.dart';
import '../../../../../utils/formatters/date_formatter.dart';
import '../../../../../utils/note_color/note_color.dart';

class NoteTextView2Split extends StatelessWidget {
  final NoteText note;
  final UserConfiguration userConfiguration;
  final bool isSelected;
  const NoteTextView2Split({
    super.key,
    required this.note,
    required this.userConfiguration,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      // Color of the note
      color: isSelected
          ? Colors.white
          : NoteColorOperations.getColorFromNumber(colorNumber: note.color),
      child: Padding(
        padding: const EdgeInsets.all(8),
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
                      DateFormatter.showLastModificationDateFormatted(
                        context: context,
                        lastModificationDate: note.lastModificationDate,
                        userConfiguration: userConfiguration,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: note.isFavorite
                        ? Stack(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amberAccent.shade400,
                                size: 28,
                              ),
                            ],
                          )
                        : const Opacity(
                            opacity: 0,
                            child: Icon(
                              Icons.circle,
                              size: 28,
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
            const SizedBox(height: 12),
            // Text body
            Text(
              note.body,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey.shade900,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
