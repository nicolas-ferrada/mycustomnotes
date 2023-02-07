import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/models/note_model.dart';

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
                showDateFormatted(lastModificationDate),
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 28),
            // Text title
            Center(
              child: Text(
                note.title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            // Text body
            Center(
              child: Text(
                note.body,
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

  // Formate the timestamp from firebase to a user friendly date
  // Day, Month, Year, Hour, Minutes
  String showDateFormatted(Timestamp lastModificationDate) {
    final DateTime dateTime = lastModificationDate.toDate();
    //final String formattedTime = DateFormat('d-M-y H:m').format(dateTime);

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    final String formattedTime = '$day-$month-${dateTime.year} $hour:$minute';

    return formattedTime;
  }
}
