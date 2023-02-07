import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/models/note_model.dart';

import '../../utils/date_formatter.dart';

class NotesWidget extends StatelessWidget {
  NotesWidget({
    super.key,
    required this.note,
    required this.index,
    required this.lastModificationDate,
  });

  final Note note;
  final int index;
  final Timestamp lastModificationDate;

  final List<Color> _lightColors = [
    Colors.amber.shade300,
    Colors.lightGreen.shade300,
    Colors.lightBlue.shade300,
    Colors.orange.shade300,
    Colors.pinkAccent.shade100,
    Colors.tealAccent.shade100
  ];

  @override
  Widget build(BuildContext context) {
    final color = _lightColors[index % _lightColors.length];

    return Card(
      color: color,
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                DateFormatter.showDateFormatted(lastModificationDate),
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 8),
            // Text title
            Center(
              child: Text(
                note.title,
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
