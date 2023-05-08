import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mycustomnotes/data/models/User/user_configuration.dart';

import '../../../../../data/models/Note/note_tasks_model.dart';
import '../../../../../utils/formatters/date_formatter.dart';
import '../../../../../utils/note_color/note_color.dart';

class NoteTasksView3Large extends StatelessWidget {
  final NoteTasks note;
  final UserConfiguration userConfiguration;
  const NoteTasksView3Large({
    super.key,
    required this.note,
    required this.userConfiguration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      // Color of the note
      color: NoteColorOperations.getColorFromNumber(colorNumber: note.color),
      child: Padding(
        padding: const EdgeInsets.all(12),
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
                            children: [
                              Icon(
                                Icons.circle,
                                color: NoteColorOperations.getColorFromNumber(
                                    colorNumber: note.color),
                                size: 46,
                              ),
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amberAccent.shade100,
                                size: 46,
                              ),
                            ],
                          )
                        : const Opacity(
                            opacity: 0,
                            child: Icon(
                              Icons.circle,
                              size: 46,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            // Text title
            Text(
              note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Text body tasks
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    min((note.tasks.length < 5 ? note.tasks.length : 5), 5),
                itemBuilder: (context, index) {
                  Map<String, dynamic> task = note.tasks[index];
                  String taskName = task['taskName'];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 32,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Flexible(
                        child: Text(
                          taskName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
