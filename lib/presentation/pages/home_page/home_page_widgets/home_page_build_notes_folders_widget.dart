import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:mycustomnotes/data/models/User/user_configuration.dart';
import 'package:mycustomnotes/presentation/pages/home_page/home_page_widgets/build_notes_tasks/build_note_tasks_note_view1_small.dart';
import 'package:mycustomnotes/presentation/pages/home_page/home_page_widgets/build_notes_tasks/build_note_tasks_note_view2_split.dart';
import 'package:mycustomnotes/presentation/pages/home_page/home_page_widgets/build_notes_tasks/build_note_tasks_note_view3_large.dart';
import 'package:mycustomnotes/presentation/pages/home_page/home_page_widgets/build_notes_text/build_note_text_note_view1_small.dart';
import 'package:mycustomnotes/presentation/pages/home_page/home_page_widgets/build_notes_text/build_note_text_note_view2_split.dart';
import 'package:mycustomnotes/presentation/pages/note_details/note_text_details_page.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/Note/folder_model.dart';
import '../../../../data/models/Note/note_notifier.dart';
import '../../../../data/models/Note/note_tasks_model.dart';
import '../../../../data/models/Note/note_text_model.dart';
import '../../../../domain/services/user_configuration_service.dart';
import '../../../../utils/extensions/compare_booleans.dart';
import '../../../routes/routes.dart';
import '../../folder/folder_details_page.dart';
import 'build_folders/build_folder_view1_small.dart';
import 'build_folders/build_folder_view2_split.dart';
import 'build_folders/build_folder_view3_large.dart';
import 'build_notes_text/build_note_text_note_view3_large.dart';

import 'dart:developer' as log;

class HomePageBuildNotesAndFoldersWidget extends StatefulWidget {
  final List<NoteText> notesTextList;
  final List<NoteTasks> notesTasksList;
  final UserConfiguration userConfiguration;
  final List<Folder>? folders;
  final bool editingFromSearchBar;
  final bool? areNotesBeingEdited;
  final Function(List<NoteText>)? updateSelectedNoteText;
  final Function(List<NoteTasks>)? updateSelectedNoteTasks;
  final Function? didSelectedNoteChanged;
  final Folder? currentFolder;
  final User? currentUser;
  final Function? updateUserConfiguration;

  const HomePageBuildNotesAndFoldersWidget({
    required this.notesTextList,
    required this.notesTasksList,
    required this.userConfiguration,
    required this.editingFromSearchBar,
    this.folders,
    this.areNotesBeingEdited,
    this.updateSelectedNoteText,
    this.updateSelectedNoteTasks,
    this.currentFolder,
    this.didSelectedNoteChanged,
    this.currentUser,
    this.updateUserConfiguration,
    super.key,
  });

  @override
  State<HomePageBuildNotesAndFoldersWidget> createState() =>
      _HomePageBuildNotesAndFoldersWidgetState();
}

class _HomePageBuildNotesAndFoldersWidgetState
    extends State<HomePageBuildNotesAndFoldersWidget> {
  // Used to store selected notes in folder's edit mode
  List<NoteText> selectedTextNotes = [];
  List<NoteTasks> selectedTasksNotes = [];

  late bool areNotesBeingVisible; // coming from user config

  List<num> selectNoteView() {
    // First option: small notes
    if (widget.userConfiguration.notesView == 1) {
      return [1, 3.5];
    }
    // Second option: split notes
    else if (widget.userConfiguration.notesView == 2) {
      return [2, 1.0];
    }
    // Third option: big notes
    else if (widget.userConfiguration.notesView == 3) {
      return [1, 1.1];
    } else {
      return [1, 2.5];
    }
  }

  // Used when accessing a created folder to only show matching notes
  List<dynamic> getStoredNotesFolder() {
    List<dynamic> storedNotesFolder = [];

    if (widget.currentFolder != null) {
      for (NoteText noteText in widget.notesTextList) {
        if (widget.currentFolder?.storedNoteTextIdField != null &&
            widget.currentFolder!.storedNoteTextIdField!
                .contains(noteText.id)) {
          storedNotesFolder.add(noteText);
        }
      }
      for (NoteTasks noteTasks in widget.notesTasksList) {
        if (widget.currentFolder?.storedNoteTasksIdField != null &&
            widget.currentFolder!.storedNoteTasksIdField!
                .contains(noteTasks.id)) {
          storedNotesFolder.add(noteTasks);
        }
      }
    }
    return storedNotesFolder;
  }

  List<NoteText> updateNewNotesEdited(NoteText? newNote) {
    List<NoteText> updatedList = List.from(widget.notesTextList);

    if (newNote != null) {
      for (int i = 0; i < updatedList.length; i++) {
        if (updatedList[i].id == newNote.id) {
          updatedList[i] = newNote;
        }
      }
    }

    return updatedList;
  }

  List<NoteText> getAlreadySelectedNoteText(List<dynamic> allNotes) {
    List<NoteText> selectedNoteText = [];

    if (widget.currentFolder != null) {
      for (var noteText in allNotes) {
        if (noteText is NoteText &&
            widget.currentFolder?.storedNoteTextIdField != null &&
            widget.currentFolder!.storedNoteTextIdField!
                .contains(noteText.id)) {
          selectedNoteText.add(noteText);
        }
      }
    }

    return selectedNoteText;
  }

  List<NoteTasks> getAlreadySelectedNoteTasks(List<dynamic> allNotes) {
    List<NoteTasks> selectedNoteTasks = [];

    if (widget.currentFolder != null) {
      for (var noteTasks in allNotes) {
        if (noteTasks is NoteTasks &&
            widget.currentFolder?.storedNoteTasksIdField != null &&
            widget.currentFolder!.storedNoteTasksIdField!
                .contains(noteTasks.id)) {
          selectedNoteTasks.add(noteTasks);
        }
      }
    }

    return selectedNoteTasks;
  }

  updateVariables() {
    setState(() {
      widget.updateUserConfiguration!();
    });
  }

  @override
  void initState() {
    super.initState();
    // if coming from search bar, always show all notes
    if (widget.editingFromSearchBar == true) {
      areNotesBeingVisible = true;
    } else {
      areNotesBeingVisible = widget.userConfiguration.areNotesBeingVisible;
    }
    List<dynamic> allNotes = [
      ...widget.notesTextList,
      ...widget.notesTasksList
    ];
    selectedTextNotes = getAlreadySelectedNoteText(allNotes);
    selectedTasksNotes = getAlreadySelectedNoteTasks(allNotes);
    // Delay function to avoid error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.updateSelectedNoteTasks != null) {
        widget.updateSelectedNoteTasks!(selectedTasksNotes);
      }
      if (widget.updateSelectedNoteText != null) {
        widget.updateSelectedNoteText!(selectedTextNotes);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Here to update lists on re-builds
    final int amountTotalNotes =
        widget.notesTextList.length + widget.notesTasksList.length;
    final int? amountTotalFolders = widget.folders?.length;
    // Build notes structure in home page
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show folders, if no folder created, show nothing
          widget.folders != null && widget.folders!.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    showAllFolders(amountTotalFolders),
                    if (amountTotalNotes > 0) ...[
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () {
                            // Tapping the tab to hide notes will only trigger if NOT coming from
                            // search bar
                            if (widget.editingFromSearchBar == false) {
                              setState(() {
                                areNotesBeingVisible = !areNotesBeingVisible;
                                UserConfigurationService.editUserConfigurations(
                                  context: context,
                                  userId: widget.currentUser!.uid,
                                  areNotesBeingVisible: areNotesBeingVisible,
                                ).then((_) async {
                                  widget.updateUserConfiguration!();
                                  Navigator.maybePop(context);
                                });
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800.withOpacity(0.8),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(9),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  areNotesBeingVisible
                                      ? Icons.arrow_circle_down_outlined
                                      : Icons.arrow_circle_right_outlined,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  areNotesBeingVisible ? 'All notes' : '',
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ],
                )
              : const SizedBox.shrink(),
          (widget.areNotesBeingEdited == null)
              // Show all notes in the homepage only if user allows it
              ? areNotesBeingVisible
                  ? showAllNotesHomePage(amountTotalNotes)
                  : const SizedBox.shrink()
              : (widget.areNotesBeingEdited != null &&
                      widget.areNotesBeingEdited == true)
                  // show the edit mode (used when creating a folder and editing them)
                  ? notesBeingEditedFolder(amountTotalNotes)
                  // show only filtered notes (stored) inside the folder
                  : notesStoredInFolder(
                      amountTotalNotes: getStoredNotesFolder().length),
        ],
      ),
    );
  }

  GridView showAllFolders(int? amountTotalFolders) {
    return GridView.custom(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 1,
          crossAxisCount: selectNoteView()[0].toInt(),
          childAspectRatio: selectNoteView()[1].toDouble()),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: amountTotalFolders,
        ((context, index) {
          // Creating a unified list of all notes
          // Ordered by date, first note created will show first
          widget.folders!
              .sort((a, b) => a.createdDate.compareTo(b.createdDate));
          // Put favorites first using a extension boolean compare
          widget.folders!.sort((a, b) =>
              CompareBooleans.compareBooleans(a.isFavorite, b.isFavorite));

          return GestureDetector(
            // Tapping on a folder, opens the detailed version of it
            onTap: () {
              Folder folder = widget.folders![index];
              navigateToFolderDetails(folder: folder);
            },
            // build each note per type/view
            child: showFolders(
              folder: widget.folders![index],
              userConfiguration: widget.userConfiguration,
            ),
          );
        }),
      ),
    );
  }

  void navigateToFolderDetails({required Folder folder, dynamic note}) {
    // when a folder is closed by double navigator.pop after a note is saved,
    // if it's being edited inside a folder, then open the same folder updated
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FolderDetailsPage(
            folder: folder,
            noteTextList: updateNewNotesEdited(note),
            noteTasksList: widget.notesTasksList,
            userConfiguration: widget.userConfiguration,
            editingFromSearchBar: widget.editingFromSearchBar,
            updateVariablesInPreviousPage: updateVariables,
          ),
        )).then((arguments) {
      if (arguments != null && arguments['isBeingEditedInFolder'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FolderDetailsPage(
              folder: folder,
              noteTextList: updateNewNotesEdited(arguments['newNote']),
              noteTasksList: widget.notesTasksList,
              userConfiguration: widget.userConfiguration,
              editingFromSearchBar: widget.editingFromSearchBar,
              updateVariablesInPreviousPage: updateVariables,
            ),
          ),
        ).then((arguments) {
          if (arguments != null && arguments['isBeingEditedInFolder']) {
            navigateToFolderDetails(folder: folder, note: arguments['newNote']);
          }
        });
      }
    });
  }

  // All notes are being shown
  GridView showAllNotesHomePage(int amountTotalNotes) {
    return GridView.custom(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 1,
          crossAxisCount: selectNoteView()[0].toInt(),
          childAspectRatio: selectNoteView()[1].toDouble()),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: amountTotalNotes,
        ((context, index) {
          // Creating a unified list of all notes
          List<dynamic> allNotes = [
            ...widget.notesTextList,
            ...widget.notesTasksList
          ];
          // Ordered by date, first note created will show first
          allNotes.sort((a, b) => a.createdDate.compareTo(b.createdDate));
          // Put favorites first using a extension boolean compare
          allNotes.sort((a, b) =>
              CompareBooleans.compareBooleans(a.isFavorite, b.isFavorite));

          return GestureDetector(
            // Tapping on a note, opens the detailed version of it
            onTap: () {
              // Check if the tapped note is a NoteText
              if (allNotes[index] is NoteText) {
                NoteText noteText = allNotes[index];
                // Open the detailed version of the NoteText
                Navigator.pushNamed(context, noteTextDetailsPageRoute,
                    arguments: {
                      'noteText': noteText,
                      'editingFromSearchBar': widget.editingFromSearchBar,
                    });
              }
              // Check if the tapped note is a NoteTasks
              else if (allNotes[index] is NoteTasks) {
                NoteTasks noteTasks = allNotes[index];
                // Open the detailed version of the NoteTasks
                Navigator.pushNamed(context, noteTasksDetailsPageRoute,
                    arguments: {
                      'noteTasks': noteTasks,
                      'editingFromSearchBar': widget.editingFromSearchBar,
                    });
              }
            },
            // build each note per type/view
            child: whatNoteToShow(
              note: allNotes[index],
              userConfiguration: widget.userConfiguration,
            ),
          );
        }),
      ),
    );
  }

  Widget notesBeingEditedFolder(int amountTotalNotes) {
    if (widget.notesTextList.isNotEmpty || widget.notesTasksList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade800.withOpacity(0.7),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: const Text(
                "Select the notes you want to add or remove from the folder, then save changes.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: GridView.custom(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 8,
                  crossAxisCount: selectNoteView()[0].toInt(),
                  childAspectRatio: selectNoteView()[1].toDouble()),
              childrenDelegate: SliverChildBuilderDelegate(
                childCount: amountTotalNotes,
                ((context, index) {
                  // Creating a unified list of all notes
                  List<dynamic> allNotes = [
                    ...widget.notesTextList,
                    ...widget.notesTasksList
                  ];
                  // Ordered by date, first note created will show first
                  allNotes
                      .sort((a, b) => a.createdDate.compareTo(b.createdDate));
                  // Put favorites first using a extension boolean compare
                  allNotes.sort((a, b) => CompareBooleans.compareBooleans(
                      a.isFavorite, b.isFavorite));

                  return GestureDetector(
                    // Tapping on notes will add/remove them from the selected notes list
                    onTap: () {
                      if (allNotes[index] is NoteText) {
                        setState(() {
                          widget.didSelectedNoteChanged!();
                          if (selectedTextNotes.contains(allNotes[index])) {
                            selectedTextNotes.remove(allNotes[index]);
                            widget.updateSelectedNoteText!(selectedTextNotes);
                            widget.updateSelectedNoteTasks!(selectedTasksNotes);
                          } else {
                            selectedTextNotes.add(allNotes[index]);
                            widget.updateSelectedNoteText!(selectedTextNotes);
                            widget.updateSelectedNoteTasks!(selectedTasksNotes);
                          }
                        });
                      }
                      // Check if the tapped note is a NoteTasks
                      else if (allNotes[index] is NoteTasks) {
                        setState(() {
                          widget.didSelectedNoteChanged!();
                          if (selectedTasksNotes.contains(allNotes[index])) {
                            selectedTasksNotes.remove(allNotes[index]);
                            widget.updateSelectedNoteText!(selectedTextNotes);
                            widget.updateSelectedNoteTasks!(selectedTasksNotes);
                          } else {
                            selectedTasksNotes.add(allNotes[index]);
                            widget.updateSelectedNoteText!(selectedTextNotes);
                            widget.updateSelectedNoteTasks!(selectedTasksNotes);
                          }
                        });
                      }
                    },
                    // build each note per type/view
                    child: whatNoteToShow(
                      note: allNotes[index],
                      userConfiguration: widget.userConfiguration,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      );
      // There are no notes created
    } else {
      return const Column(
        children: [
          SizedBox(
            height: 128,
          ),
          Center(
              child: Text(
            'You have no notes created!',
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          )),
          SizedBox(
            height: 16,
          ),
          Center(
              child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Create notes first, so you can add them to the folder.',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          )),
        ],
      );
    }
  }

  // Folder, showing stored notes in it
  notesStoredInFolder({
    required int amountTotalNotes,
  }) {
    if (amountTotalNotes > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GridView.custom(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 0,
                crossAxisCount: selectNoteView()[0].toInt(),
                childAspectRatio: selectNoteView()[1].toDouble()),
            childrenDelegate: SliverChildBuilderDelegate(
              childCount: amountTotalNotes,
              ((context, index) {
                // Creating a unified list of all notes
                List<dynamic> allNotes = getStoredNotesFolder();
                // Ordered by date, first note created will show first
                allNotes.sort((a, b) => a.createdDate.compareTo(b.createdDate));
                // Put favorites first using a extension boolean compare
                allNotes.sort((a, b) => CompareBooleans.compareBooleans(
                    a.isFavorite, b.isFavorite));

                return GestureDetector(
                  // Tapping on notes will add/remove them from the selected notes list
                  onTap: () {
                    if (allNotes[index] is NoteText) {
                      NoteText noteText = allNotes[index];
                      // Open the detailed version of the NoteText
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteTextDetailsPage(
                            noteText: noteText,
                            editingFromSearchBar: widget.editingFromSearchBar,
                            isBeingEditedInFolder: true,
                          ),
                        ),
                      );
                    }
                    // Check if the tapped note is a NoteTasks
                    else if (allNotes[index] is NoteTasks) {
                      NoteTasks noteTasks = allNotes[index];
                      // Open the detailed version of the NoteTasks
                      Navigator.pushNamed(context, noteTasksDetailsPageRoute,
                          arguments: {
                            'noteTasks': noteTasks,
                            'editingFromSearchBar': widget.editingFromSearchBar,
                          });
                    }
                  },
                  // build each note per type/view
                  child: whatNoteToShow(
                    note: allNotes[index],
                    userConfiguration: widget.userConfiguration,
                  ),
                );
              }),
            ),
          ),
        ],
      );
    } else {
      return const Column(
        children: [
          SizedBox(
            height: 128,
          ),
          Center(
              child: Text(
            'Your folder is empty',
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          )),
          SizedBox(
            height: 16,
          ),
          Center(
              child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Press the three dots on the top right corner and press edit, then tap the notes you want to add to this folder and save.',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          )),
        ],
      );
    }
  }

  whatNoteToShow({
    required dynamic note,
    required UserConfiguration userConfiguration,
  }) {
    // Note text
    if (note is NoteText && userConfiguration.notesView == 1) {
      return NoteTextView1Small(
        note: note,
        userConfiguration: userConfiguration,
        isSelected: widget.areNotesBeingEdited != null &&
                widget.areNotesBeingEdited == true
            ? selectedTextNotes.contains(note)
            : false,
      );
    } else if (note is NoteText && userConfiguration.notesView == 2) {
      return NoteTextView2Split(
        note: note,
        userConfiguration: userConfiguration,
        isSelected: widget.areNotesBeingEdited != null &&
                widget.areNotesBeingEdited == true
            ? selectedTextNotes.contains(note)
            : false,
      );
    } else if (note is NoteText && userConfiguration.notesView == 3) {
      return NoteTextView3Large(
        note: note,
        userConfiguration: userConfiguration,
        isSelected: widget.areNotesBeingEdited != null &&
                widget.areNotesBeingEdited == true
            ? selectedTextNotes.contains(note)
            : false,
      );
    }
    // Note tasks
    else if (note is NoteTasks && userConfiguration.notesView == 1) {
      return NoteTasksView1Small(
        note: note,
        userConfiguration: userConfiguration,
        isSelected: widget.areNotesBeingEdited != null &&
                widget.areNotesBeingEdited == true
            ? selectedTasksNotes.contains(note)
            : false,
      );
    } else if (note is NoteTasks && userConfiguration.notesView == 2) {
      return NoteTasksView2Split(
        note: note,
        userConfiguration: userConfiguration,
        isSelected: widget.areNotesBeingEdited != null &&
                widget.areNotesBeingEdited == true
            ? selectedTasksNotes.contains(note)
            : false,
      );
    } else if (note is NoteTasks && userConfiguration.notesView == 3) {
      return NoteTasksView3Large(
        note: note,
        userConfiguration: userConfiguration,
        isSelected: widget.areNotesBeingEdited != null &&
                widget.areNotesBeingEdited == true
            ? selectedTasksNotes.contains(note)
            : false,
      );
    } else {
      throw Exception(
          'Something went wrong, that type of Note or Note view does not exists');
    }
  }

  showFolders({
    required Folder folder,
    required UserConfiguration userConfiguration,
  }) {
    // Note text
    if (userConfiguration.notesView == 1) {
      return FolderView1Small(
        folder: folder,
        userConfiguration: userConfiguration,
      );
    } else if (userConfiguration.notesView == 2) {
      return FolderView2Split(
        folder: folder,
        userConfiguration: userConfiguration,
      );
    } else if (userConfiguration.notesView == 3) {
      return FolderView3Large(
        folder: folder,
        userConfiguration: userConfiguration,
      );
    }
  }
}
