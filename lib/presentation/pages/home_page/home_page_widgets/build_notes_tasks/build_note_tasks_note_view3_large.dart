import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mycustomnotes/data/models/User/user_configuration.dart';

import '../../../../../data/models/Note/note_tasks_model.dart';
import '../../../../../l10n/l10n_export.dart';
import '../../../../../utils/formatters/date_formatter.dart';
import '../../../../../utils/note_color/note_color.dart';

// ignore: must_be_immutable
class NoteTasksView3Large extends StatelessWidget {
  final NoteTasks note;
  final UserConfiguration userConfiguration;
  NoteTasksView3Large({
    super.key,
    required this.note,
    required this.userConfiguration,
  });

  bool didNoTaskToDoMessageShow = false;

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
            // Text body of tasks
            note.tasks.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: min(
                          (note.tasks.length < 5 ? note.tasks.length : 5), 5),
                      itemBuilder: (context, index) {
                        // Reversing the list to get last values
                        List<Map<String, dynamic>> taskListMap =
                            List.from(note.tasks.reversed);
                        // Filters only the tasks not completed and add their names to completedTaskListNames
                        List<String> completedTaskListNames = taskListMap
                            .where((taskMap) =>
                                taskMap['isTaskCompleted'] == false)
                            .map((taskMap) => taskMap['taskName'].toString())
                            .toList();
                        if (index < completedTaskListNames.length) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                Icons.circle_outlined,
                                size: 24,
                                color: Colors.white70,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: Text(
                                  completedTaskListNames[index],
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
                        } else {
                          if (completedTaskListNames.isEmpty &&
                              didNoTaskToDoMessageShow == false) {
                            didNoTaskToDoMessageShow = true;
                            return Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .noteTasks_text_buildNotesAllCompleted,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }
                      },
                    ),
                  )
                : Text(
                    AppLocalizations.of(context)!
                        .noteTasks_text_buildNotesNoTasksAdded,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 24,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
