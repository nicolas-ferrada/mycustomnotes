import 'dart:math';

import 'package:flutter/material.dart';
import '../../../../../data/models/User/user_configuration.dart';

import '../../../../../data/models/Note/note_tasks_model.dart';
import '../../../../../l10n/l10n_export.dart';
import '../../../../../utils/enums/last_modification_date_formats_enum.dart';
import '../../../../../utils/formatters/date_formatter.dart';
import '../../../../../utils/note_color/note_color.dart';

// ignore: must_be_immutable
class NoteTasksView1Small extends StatelessWidget {
  final NoteTasks note;
  final UserConfiguration userConfiguration;
  final bool isSelected;
  NoteTasksView1Small({
    super.key,
    required this.note,
    required this.userConfiguration,
    required this.isSelected,
  });

  bool didNoTaskToDoMessageShow = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.white70 : Colors.grey.shade900,
      shape: const BeveledRectangleBorder(),
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text title
                  Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Text body of tasks
                  note.tasks.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: min(
                                (note.tasks.length < 3 ? note.tasks.length : 3),
                                3),
                            itemBuilder: (context, index) {
                              // Reversing the list to get last values
                              List<Map<String, dynamic>> taskListMap =
                                  List.from(note.tasks.reversed);
                              // Filters only the tasks not completed and add their names to completedTaskListNames
                              List<String> completedTaskListNames = taskListMap
                                  .where((taskMap) =>
                                      taskMap['isTaskCompleted'] == false)
                                  .map((taskMap) =>
                                      taskMap['taskName'].toString())
                                  .toList();
                              if (index < completedTaskListNames.length) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.circle_outlined,
                                      size: 12,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Flexible(
                                      child: Text(
                                        completedTaskListNames[index],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                if (completedTaskListNames.isEmpty &&
                                    didNoTaskToDoMessageShow == false) {
                                  didNoTaskToDoMessageShow = true;
                                  return Text(
                                    AppLocalizations.of(context)!
                                        .noteTasks_text_buildNotesAllCompleted,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white70,
                                      fontSize: 12,
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
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                        ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        height: 14,
                      ),
                      note.isFavorite
                          ? Stack(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: Colors.amberAccent.shade200,
                                  size: 28,
                                ),
                              ],
                            )
                          : const Opacity(
                              opacity: 0,
                              child: Icon(
                                Icons.star_rounded,
                                size: 28,
                              ),
                            ),
                      Stack(
                        children: [
                          // if it's 24 hrs, dont show it, if its 12 hours, show it
                          Visibility(
                            visible: is12HoursFormat(),
                            child: Opacity(
                              opacity: 0,
                              child: Text(
                                '12:00 PM',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          // show max length if is 24 hours format
                          Visibility(
                            visible: !is12HoursFormat(),
                            child: Opacity(
                              opacity: 0,
                              child: Text(
                                'Jan 01',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Text(
                            // Date of last modification
                            DateFormatter.showLastModificationDateFormatted(
                              context: context,
                              lastModificationDate: note.lastModificationDate,
                              userConfiguration: userConfiguration,
                            ),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: NoteColorOperations.getColorFromNumber(
                              colorNumber: note.color),
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool is12HoursFormat() {
    if (userConfiguration.dateTimeFormat ==
            LastModificationDateFormat.dayMonthYear.value +
                LastModificationTimeFormat.hours12.value ||
        userConfiguration.dateTimeFormat ==
            LastModificationDateFormat.yearMonthDay.value +
                LastModificationTimeFormat.hours12.value ||
        userConfiguration.dateTimeFormat ==
            LastModificationDateFormat.monthDayYear.value +
                LastModificationTimeFormat.hours12.value) {
      return true;
    } else {
      return false;
    }
  }
}
