import 'package:flutter/material.dart';
import '../../../../../data/models/User/user_configuration.dart';

import '../../../../../data/models/Note/folder_model.dart';
import '../../../../../utils/note_color/note_color.dart';

class FolderView1Small extends StatelessWidget {
  final Folder folder;
  final UserConfiguration userConfiguration;
  const FolderView1Small({
    super.key,
    required this.folder,
    required this.userConfiguration,
  });

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
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text title
                    Text(
                      folder.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
                    folder.isFavorite
                        ? Stack(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amberAccent.shade200,
                                size: 36,
                              ),
                            ],
                          )
                        : const Opacity(
                            opacity: 0,
                            child: Icon(
                              Icons.star_rounded,
                              size: 36,
                            ),
                          ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: NoteColorOperations.getColorFromNumber(
                                colorNumber: folder.color),
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.folder,
                          color: Colors.white,
                          size: 36,
                        ),
                      ],
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
}
