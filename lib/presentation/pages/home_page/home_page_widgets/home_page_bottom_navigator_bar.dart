import 'package:flutter/material.dart';
import '../../../../data/models/Note/note_tasks_model.dart';
import '../../../../data/models/User/user_configuration.dart';
import '../../../../l10n/l10n_export.dart';

import '../../../../data/models/Note/note_text_model.dart';
import '../../../../utils/dialogs/select_create_note_type.dart';
import '../../folder/folder_details_page.dart';

class BottomNavigationBarHomePage extends StatefulWidget {
  final UserConfiguration userConfiguration;
  final List<NoteText> notesTextList;
  final List<NoteTasks> notesTasksList;
  const BottomNavigationBarHomePage({
    super.key,
    required this.userConfiguration,
    required this.notesTasksList,
    required this.notesTextList,
  });

  @override
  State<BottomNavigationBarHomePage> createState() =>
      _BottomNavigationBarHomePageState();
}

class _BottomNavigationBarHomePageState
    extends State<BottomNavigationBarHomePage> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (itemTapped) async {
        if (itemTapped == 0) {
          // Create folder
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FolderDetailsPage(
                noteTextList: widget.notesTextList,
                noteTasksList: widget.notesTasksList,
                userConfiguration: widget.userConfiguration,
              ),
            ),
          );
        } else if (itemTapped == 1) {
          // Create note
          await SelectCreateNoteType.noteDetailsDialog(context);
        } else {
          throw Exception('Item not found');
        }
      },
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      iconSize: 26,
      selectedFontSize: 13,
      unselectedFontSize: 13,
      unselectedItemColor: Colors.white70,
      selectedItemColor: Colors.white70,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.folder),
          label: 'Crear carpeta',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.create),
          label: AppLocalizations.of(context)!.newNote_floatingButton_homePage,
        ),
      ],
    );
  }
}
