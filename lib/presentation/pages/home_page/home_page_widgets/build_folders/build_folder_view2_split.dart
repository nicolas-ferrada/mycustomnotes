import 'package:flutter/material.dart';
import 'package:mycustomnotes/data/models/User/user_configuration.dart';

import '../../../../../data/models/Note/folder_model.dart';
import '../../../../../utils/note_color/note_color.dart';

class FolderView2Split extends StatelessWidget {
  final Folder folder;
  final UserConfiguration userConfiguration;
  const FolderView2Split({
    super.key,
    required this.folder,
    required this.userConfiguration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      // Color of the folder
      color: NoteColorOperations.getColorFromNumber(colorNumber: folder.color),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top of the folder
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.folder,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: folder.isFavorite
                        ? Stack(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amberAccent.shade400,
                                size: 36,
                              ),
                            ],
                          )
                        : const Opacity(
                            opacity: 0,
                            child: Icon(
                              Icons.circle,
                              size: 36,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Folders name
            Text(
              folder.name,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
