import 'package:flutter/material.dart';
import '../../../../l10n/l10n_export.dart';

import '../../../../data/models/Note/folder_model.dart';
import '../../../../data/models/Note/note_tasks_model.dart';
import '../../../../data/models/Note/note_text_model.dart';
import '../../../../data/models/User/user_configuration.dart';
import 'home_page_build_notes_folders_widget.dart';

class AppBarHomePage extends StatefulWidget {
  final List<NoteText> textNotes;
  final List<NoteTasks> tasksNotes;
  final UserConfiguration userConfiguration;
  final List<Folder> folders;
  const AppBarHomePage({
    super.key,
    required this.textNotes,
    required this.tasksNotes,
    required this.userConfiguration,
    required this.folders,
  });

  @override
  State<AppBarHomePage> createState() => _AppBarHomePageState();
}

class _AppBarHomePageState extends State<AppBarHomePage> {
  List<NoteText> filteredTextNotes = [];
  List<NoteTasks> filteredTasksNotes = [];
  List<Folder> filteredFolders = [];
  final TextEditingController filter = TextEditingController();

  @override
  void dispose() {
    filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Custom Notes',
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.settings,
            size: 29,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                size: 32,
              ),
              onPressed: () async {
                searchForNotes();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> searchForNotes() async {
    return await showModalBottomSheet(
      backgroundColor: Colors.grey.shade900,
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: filter,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          filterTextNotes();
                          filterTasksNotes();
                          filterFolders();
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 32,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 27, 27, 27),
                        hintText: AppLocalizations.of(context)!
                            .searchNote_text_appbarTextfield,
                      ),
                    ),
                  ),
                  // If is empty, user did not apply any filter yet.
                  (widget.tasksNotes.isNotEmpty ||
                          widget.textNotes.isNotEmpty ||
                          widget.folders.isNotEmpty)
                      ? Expanded(
                          child: filter.text.isEmpty
                              ? HomePageBuildNotesAndFoldersWidget(
                                  notesTasksList: widget.tasksNotes,
                                  notesTextList: widget.textNotes,
                                  userConfiguration: widget.userConfiguration,
                                  folders: widget.folders,
                                  editingFromSearchBar: true,
                                )
                              // User is writing in the filter
                              : HomePageBuildNotesAndFoldersWidget(
                                  notesTasksList: filteredTasksNotes,
                                  notesTextList: filteredTextNotes,
                                  folders: filteredFolders,
                                  userConfiguration: widget.userConfiguration,
                                  editingFromSearchBar: true,
                                ),
                        )
                      : Center(
                          child: Text(AppLocalizations.of(context)!
                              .noNotesCreated_text_homePage),
                        )
                ],
              ),
            );
          },
        );
      },
    ).then(
      (_) {
        filter.clear();
        return null;
      },
    );
  }

  // If the title or body of the note contains the filter String, add them to the filtered var
  filterTextNotes() {
    filteredTextNotes = widget.textNotes.where((note) {
      final noteTitle = note.title.toLowerCase();
      final noteBody = note.body.toLowerCase();
      final input = filter.text.toLowerCase();

      final bool notes = noteTitle.contains(input) || noteBody.contains(input);
      return notes;
    }).toList();
  }

  filterTasksNotes() {
    filteredTasksNotes = widget.tasksNotes.where((note) {
      final noteTitle = note.title.toLowerCase();
      final input = filter.text.toLowerCase();
      final List<Map<String, dynamic>> taskList = note.tasks;

      for (final taskMap in taskList) {
        final taskName = taskMap['taskName'].toLowerCase();
        if (taskName.contains(input) || noteTitle.contains(input)) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  filterFolders() {
    filteredFolders = widget.folders.where((folder) {
      final folderTitle = folder.name.toLowerCase();
      final input = filter.text.toLowerCase();

      final bool folders = folderTitle.contains(input);
      return folders;
    }).toList();
  }
}
