import 'package:flutter/material.dart';
import 'package:mycustomnotes/data/models/User/user_configuration.dart';

import '../../../../../data/models/Note/note_text_model.dart';
import '../../../../../utils/enums/last_modification_date_formats_enum.dart';
import '../../../../../utils/formatters/date_formatter.dart';
import '../../../../../utils/note_color/note_color.dart';

class NoteTextView1Small extends StatelessWidget {
  final NoteText note;
  final UserConfiguration userConfiguration;
  const NoteTextView1Small(
      {super.key, required this.note, required this.userConfiguration});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      shape: const BeveledRectangleBorder(),
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 18, 16, 16),
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
                  const SizedBox(height: 10),
                  // Text body
                  Text(
                    note.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
                        // show max length if is 12 hours format (so rectangles are all the same size)
                        Visibility(
                          visible: is12HoursFormat(),
                          child: Opacity(
                            opacity: 0,
                            child: Text(
                              '12:00 AM',
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
