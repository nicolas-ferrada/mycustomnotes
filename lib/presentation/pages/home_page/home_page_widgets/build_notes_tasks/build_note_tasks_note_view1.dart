import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../data/models/Note/note_tasks_model.dart';
import '../../../../../utils/formatters/date_formatter.dart';
import '../../../../../utils/note_color/note_color.dart';

class NoteTasksView1 extends StatelessWidget {
  final NoteTasks note;
  const NoteTasksView1({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
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
  }
}
