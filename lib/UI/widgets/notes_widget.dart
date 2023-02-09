import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter/material.dart';
import 'package:mycustomnotes/models/note_model.dart';
import '../../utils/date_formatter.dart';

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
  Color noteColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Card(
      // Color of the note
      color: pickNoteColor(),
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    // Date of last modification
                    DateFormatter.showDateFormatted(
                        widget.lastModificationDate),
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 10),
                  // Icon is favorite, if true, shows yellow start, if false, shows nothing
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
                      : null,
                )
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

  Color pickNoteColor() {
    switch (widget.note.color) {
      case 1:
        {
          setState(() {
            noteColor = Colors.amber.shade300;
          });
        }
        return noteColor;
      case 2:
        {
          setState(() {
            noteColor = Colors.green.shade300;
          });
        }
        return noteColor;
      case 3:
        {
          setState(() {
            noteColor = Colors.lightBlue.shade300;
          });
        }
        return noteColor;
      case 4:
        {
          setState(() {
            noteColor = Colors.orange.shade300;
          });
        }
        return noteColor;
      case 5:
        {
          setState(() {
            noteColor = Colors.pinkAccent.shade100;
          });
        }
        return noteColor;
      case 6:
        {
          setState(() {
            noteColor = Colors.tealAccent.shade100;
          });
        }
        return noteColor;
      default:
        {
          setState(() {
            noteColor = Colors.grey;
          });
        }
        return noteColor;
    }
  }
}
