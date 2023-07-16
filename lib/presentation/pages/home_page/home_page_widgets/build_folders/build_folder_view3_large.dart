import 'package:flutter/material.dart';
import '../../../../../data/models/User/user_configuration.dart';

import '../../../../../data/models/Note/folder_model.dart';
import '../../../../../utils/note_color/note_color.dart';

class FolderView3Large extends StatelessWidget {
  final Folder folder;
  final UserConfiguration userConfiguration;
  const FolderView3Large({
    super.key,
    required this.folder,
    required this.userConfiguration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      // Color
      color: NoteColorOperations.getColorFromNumber(colorNumber: folder.color),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.folder,
                        color: Colors.white,
                        size: 52,
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
                                  size: 52,
                                ),
                              ],
                            )
                          : const Opacity(
                              opacity: 0,
                              child: Icon(
                                Icons.circle,
                                size: 52,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Folders name
              Text(
                folder.name,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
