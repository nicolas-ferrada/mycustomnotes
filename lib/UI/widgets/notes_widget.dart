import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter/material.dart';
import 'package:mycustomnotes/models/note_model.dart';
import '../../utils/dialogs/pick_note_color.dart';
import '../../utils/formatters/date_formatter.dart';

class NotesWidget extends StatefulWidget {
  final Note note;
  final int index;
  final Timestamp lastModificationDate;
  final bool isFavorite;

  const NotesWidget({
    super.key,
    required this.note,
    required this.index,
    required this.lastModificationDate,
    required this.isFavorite,
  });

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      // Color of the note
      color: NotesColors.selectNoteColor(widget.note.color),
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
                    DateFormatter.showDateFormatted(
                        widget.lastModificationDate),
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: widget.isFavorite
                        ? const Stack(
                            children: [
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
                          child: Stack(
                            children: [
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
                widget.note.title,
                maxLines: 2,
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
                widget.note.body,
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
