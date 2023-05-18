import 'package:flutter/material.dart';
import '../../../data/models/Note/note_notifier.dart';
import '../../../data/models/Note/note_tasks_model.dart';
import '../../../domain/services/auth_user_service.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../domain/services/note_tasks_service.dart';
import '../../../l10n/l10n_export.dart';
import '../../../utils/dialogs/confirmation_dialog.dart';
import '../../../utils/dialogs/delete_note_confirmation.dart';
import '../../../utils/dialogs/note_details_info.dart';
import '../../../utils/dialogs/note_pick_color_dialog.dart';
import '../../../utils/enums/menu_item_note_detail.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../../utils/internet/check_internet_connection.dart';
import '../../../utils/note_color/note_color.dart';
import '../../../utils/snackbars/snackbar_message.dart';

class Tasks {
  bool isTaskCompleted;
  String taskName;

  Tasks({
    required this.isTaskCompleted,
    required this.taskName,
  });
}

class NoteTasksDetailsPage extends StatefulWidget {
  final NoteTasks noteTasks;
  const NoteTasksDetailsPage({super.key, required this.noteTasks});

  @override
  State<NoteTasksDetailsPage> createState() => _NoteTasksDetailsPageState();
}

class _NoteTasksDetailsPageState extends State<NoteTasksDetailsPage> {
  // Access firebase user
  final currentUser = AuthUserService.getCurrentUserFirebase();

  // Makes the save button to show up
  bool didTitleChange = false;
  bool didTaskChange = false;
  bool didColorChange = false;
  bool didFavoriteChange = false;

  // Only set state once to make the save button show
  bool didUserModifiedTaskForFirstTime = false;

  // Avoids dialog of leaving page confirmation to triggers if the save button was pressed
  bool wasTheSaveButtonPressed = false;

  // Handles the color of the favorite star icon and color palette icon
  late Color isFavoriteIconColor;
  late Color colorIconPalette;

  // New note object which is going to be modified so it can be stored later with the new data
  late NoteTasks newNote;

  // List of tasks
  late final List<Tasks> tasksList;

  // if false, completed notes will dissapear and the arrow icon will point to the right
  bool areCompletedNotesVisible = true;

  // New task controller
  final TextEditingController _newTaskTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateNote();
  }

  void updateNote() {
    // Copy the original object to create the a new note, which attributes will be modified by user
    newNote = widget.noteTasks.copyWith();
    if (widget.noteTasks.isFavorite) {
      isFavoriteIconColor = Colors.amber;
    } else {
      isFavoriteIconColor = Colors.white;
    }
    colorIconPalette = NoteColorOperations.getColorFromNumber(
        colorNumber: widget.noteTasks.color);

    tasksList = getTaskListFromMapList(newNote.tasks);
  }

  List<Tasks> getTaskListFromMapList(List<Map<String, dynamic>> mapList) {
    List<Tasks> taskList = [];
    for (var map in mapList) {
      Tasks task = Tasks(
        isTaskCompleted: map['isTaskCompleted'],
        taskName: map['taskName'],
      );
      taskList.add(task);
    }
    return taskList;
  }

  bool didUserMadeChanges() {
    bool didUserMadeChanges = (didTitleChange ||
        didFavoriteChange ||
        didColorChange ||
        didTaskChange);
    return didUserMadeChanges;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Avoids the bug of the keyboard showing for a sec
        FocusScope.of(context).unfocus();
        // Triggers a warning for leaving when user made changes and the save button was not pressed
        if (didUserMadeChanges() == true && wasTheSaveButtonPressed == false) {
          final bool? shouldPop =
              await ConfirmationDialog.discardChangesNoteDetails(context);
          return shouldPop ??
              false; // If user tap outside dialog, then don't leave page
        } else {
          return true; // Come back to home page
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // Note actions (three dots detais)
            menuButtonNote(),
          ],
          // Note's title
          title: TextFormField(
            initialValue: widget.noteTasks.title,
            onChanged: (newTitleChanged) {
              // Changes are being made
              if (newTitleChanged != widget.noteTasks.title) {
                setState(() {
                  didTitleChange = true;
                });
                newNote.title = newTitleChanged.trim();
                // No changes
              } else {
                setState(() {
                  didTitleChange = false;
                });
              }
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Title',
              hintStyle: TextStyle(color: Colors.white70),
            ),
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tasks not completed
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ReorderableListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: tasksList.length,
                  itemBuilder: (context, index) {
                    final task = tasksList[index];
                    // return buildTasksNotCompleted(index: index, task: task);
                    return buildTasksNotCompleted(index: index, task: task);
                  },
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      final index =
                          (newIndex > oldIndex) ? newIndex - 1 : newIndex;
                      final task = tasksList.removeAt(oldIndex);
                      tasksList.insert(index, task);
                      newNote.tasks = getValues();
                      didTaskChange = true;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              // Tasks completed
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      areCompletedNotesVisible = !areCompletedNotesVisible;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800.withOpacity(0.9),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(9),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          areCompletedNotesVisible
                              ? Icons.arrow_circle_down_outlined
                              : Icons.arrow_circle_right_outlined,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Text(
                          'Tasks completed',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: areCompletedNotesVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: tasksList.length,
                    itemBuilder: (context, index) {
                      final task = tasksList[index];
                      return buildTasksCompleted(index: index, task: task);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        // Save button, only visible if user changes the note
        floatingActionButton:
            noteTasksDetailsPageCreateNoteFloatingActionButton(context),
      ),
    );
  }

  Widget buildTasksNotCompleted({
    required int index,
    required Tasks task,
  }) {
    if (task.isTaskCompleted == false) {
      return Padding(
        // Make each tile unique
        key: ValueKey(task),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Dismissible(
          key: ValueKey(task),
          onDismissed: (_) {
            tasksList.removeAt(index);
            newNote.tasks = getValues();
            setState(() {
              didTaskChange = true;
            });
          },
          background: Container(
            color: Colors.redAccent,
            child: const Icon(Icons.delete),
          ),
          child: Container(
            // If the color is in the ListTile, a visual bug happens on dragging tasks
            color: Colors.white24,
            child: ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final task = tasksList[index];
                    return AlertDialog(
                      content: TextFormField(
                        autofocus: true,
                        initialValue: task.taskName,
                        onFieldSubmitted: (_) => Navigator.maybePop(context),
                        onTapOutside: (_) => Navigator.maybePop(context),
                        // Task modification
                        onChanged: (value) => setState(
                          () {
                            task.taskName = value;
                            newNote.tasks = getValues();
                            didTaskChange = true;
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding: const EdgeInsets.all(8),
              // isTaskCompleted Checkbox
              leading: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  activeColor: const Color.fromRGBO(250, 216, 90, 0.8),
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  value: task.isTaskCompleted,
                  onChanged: (value) {
                    setState(() {
                      task.isTaskCompleted = value!;
                      newNote.tasks = getValues();
                      didTaskChange = true;
                    });
                  },
                ),
              ),
              // Task name
              title: Text(task.taskName),
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink(
        key: ValueKey(task),
      );
    }
  }

  Widget buildTasksCompleted({
    required int index,
    required Tasks task,
  }) {
    if (task.isTaskCompleted == true) {
      return Padding(
        // Make each tile unique
        key: ValueKey(task),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Dismissible(
          key: ValueKey(task),
          onDismissed: (direction) {
            setState(() {
              tasksList.removeAt(index);
              newNote.tasks = getValues();
              didTaskChange = true;
            });
          },
          background: Container(
            color: Colors.redAccent,
            child: const Icon(Icons.delete),
          ),
          child: Container(
            // If the color is in the ListTile, a visual bug happens on dragging tasks
            color: Colors.white24,
            child: ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final task = tasksList[index];
                    return AlertDialog(
                      content: TextFormField(
                        autofocus: true,
                        initialValue: task.taskName,
                        onFieldSubmitted: (_) => Navigator.maybePop(context),
                        onTapOutside: (_) => Navigator.maybePop(context),
                        // Task modification
                        onChanged: (value) => setState(
                          () {
                            task.taskName = value;
                            newNote.tasks = getValues();
                            didTaskChange = true;
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding: const EdgeInsets.all(8),
              // isTaskCompleted Checkbox
              leading: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  activeColor: const Color.fromRGBO(250, 216, 90, 0.8),
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  value: task.isTaskCompleted,
                  onChanged: (value) {
                    setState(() {
                      task.isTaskCompleted = value!;
                      newNote.tasks = getValues();
                      didTaskChange = true;
                    });
                  },
                ),
              ),
              // Task name
              title: Text(task.taskName),
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink(
        key: ValueKey(task),
      );
    }
  }

  Widget noteTasksDetailsPageCreateNoteFloatingActionButton(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: didUserMadeChanges(),
          child: FloatingActionButton(
            heroTag: null,
            tooltip: 'Save changes',
            shape: const CircleBorder(),
            onPressed: () async {
              // Create note button
              try {
                wasTheSaveButtonPressed = true;
                // Check if device it's connected to any network
                bool isDeviceConnected =
                    await CheckInternetConnection.checkInternetConnection();
                int waitingConnection = 5;

                // If device is connected, wait 5 seconds, if is not connected, dont wait.
                if (isDeviceConnected) {
                  waitingConnection = 5;
                } else {
                  waitingConnection = 0;
                }

                // Create note on firebase, it will wait depending if the device it's connected to a network
                await NoteTasksService.editNoteTasks(
                  note: newNote,
                ).timeout(
                  Duration(seconds: waitingConnection),
                  onTimeout: () {
                    Provider.of<NoteNotifier>(context, listen: false)
                        .refreshNotes();

                    Navigator.of(context).maybePop();
                  },
                );
                if (context.mounted) {
                  Provider.of<NoteNotifier>(context, listen: false)
                      .refreshNotes();

                  Navigator.of(context).maybePop();
                }
              } catch (errorMessage) {
                ExceptionsAlertDialog.showErrorDialog(
                    context: context, errorMessage: errorMessage.toString());
              }
            },
            backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
            child: const Icon(Icons.save),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        FloatingActionButton(
          shape: const CircleBorder(),
          heroTag: null,
          tooltip: 'Add a new task',
          onPressed: () async {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(),
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: TextField(
                                controller: _newTaskTextController,
                                autofocus: true,
                                onSubmitted: (_) {
                                  creatingNewTask();
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Create a new task',
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              creatingNewTask();
                            },
                            icon: const Icon(Icons.done),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  void creatingNewTask() {
    if (_newTaskTextController.text.isNotEmpty) {
      addNewTask();
      _newTaskTextController.clear(); // restart text value
      setState(() {
        didTaskChange = true;
        newNote.tasks = getValues();
      });
      FocusScope.of(context).unfocus();
    } else {
      // task is empty
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarMessage.snackBarMessage(
            message: "You can't create an empty task",
            backgroundColor: Colors.red),
      );
      FocusScope.of(context).unfocus();
    }
  }

  void addNewTask() {
    setState(() {
      tasksList.add(
          Tasks(isTaskCompleted: false, taskName: _newTaskTextController.text));
    });
  }

  List<Map<String, dynamic>> getValues() {
    return tasksList
        .map((task) => {
              'isTaskCompleted': task.isTaskCompleted,
              'taskName': task.taskName
            })
        .toList();
  }

  // Menu note button (icon three dots)
  PopupMenuButton menuButtonNote() {
    // Required
    // IMPORTANT: Current note, didUserMadeChanges so to know when ask the user to save
    // Less important: Icons colors
    return PopupMenuButton(
      onSelected: (value) async {
        if (value == MenuItemNoteDetail.item1) {
          // Mark as favorite
          markAsFavoritePopupButton();
        } else if (value == MenuItemNoteDetail.item2) {
          // Pick color palette
          pickNoteColorPopupButton();
        } else if (value == MenuItemNoteDetail.item4) {
          // Share note
          String getTasksFormat() {
            String tasksFormat = '';
            for (int i = 0; i < widget.noteTasks.tasks.length; i++) {
              String taskStatus = widget.noteTasks.tasks[i]['isTaskCompleted']
                  ? 'completed'
                  : 'not completed';
              tasksFormat +=
                  '${i + 1}) ${widget.noteTasks.tasks[i]['taskName']}, $taskStatus\n';
            }
            return tasksFormat;
          }

          Share.share('${widget.noteTasks.title}\n\n${getTasksFormat()}');
        } else if (value == MenuItemNoteDetail.item5) {
          // Note details
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return NotesDetails(
                context: context,
                note: widget.noteTasks,
              );
            },
          );
        } else if (value == MenuItemNoteDetail.item6) {
          // Delete note
          try {
            DeleteNoteConfirmation.deleteNoteDialog(
                context: context, note: widget.noteTasks);
          } catch (errorMessage) {
            await ExceptionsAlertDialog.showErrorDialog(
                context: context, errorMessage: errorMessage.toString());
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: MenuItemNoteDetail.item1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // If it's favorite, show yellow icon, if not, white
              Icon(
                Icons.star,
                color: isFavoriteIconColor,
                size: 28,
              ),
              Text(AppLocalizations.of(context)!
                  .noteFunctionsMenu_popupMenu_favorite),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.palette,
                size: 28,
                color: colorIconPalette,
              ),
              Text(AppLocalizations.of(context)!
                  .noteFunctionsMenu_popupMenu_color),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item4,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.share, size: 28),
              Text(
                AppLocalizations.of(context)!.noteFunctionsMenu_popupMenu_share,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item5,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.info, size: 28),
              Text(AppLocalizations.of(context)!
                  .noteFunctionsMenu_popupMenu_details),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item6,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.delete, size: 28),
              Text(AppLocalizations.of(context)!
                  .noteFunctionsMenu_popupMenu_delete),
            ],
          ),
        ),
      ],
    );
  }

  // POPUPMENU BUTTONS

  // PopupButton favorite
  void markAsFavoritePopupButton() {
    // The new note it's not favorite, so change it to favorite
    if (!newNote.isFavorite) {
      newNote.isFavorite = true;
      setState(() {
        isFavoriteIconColor = Colors.amber;
      });
      // Note now it's favorite, if it was favorite from the start, then user did not make any changes
      if (widget.noteTasks.isFavorite) {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message:
              AppLocalizations.of(context)!.favorite_snackbar_noteMarkedAgain,
          backgroundColor: Colors.amber.shade300,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didFavoriteChange = false;
        });
        // Note now it's favorite, but it wasn't from the start, so user made a change
      } else {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message: AppLocalizations.of(context)!.favorite_snackbar_noteMarked,
          backgroundColor: Colors.amber.shade300,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didFavoriteChange = true;
        });
      }
    } else {
      // It's favorite, so change it to not favorite
      newNote.isFavorite = false;
      setState(() {
        isFavoriteIconColor = Colors.white;
      });
      // Note now it's not favorite, if it was favorite from the start, then user did make a change
      if (widget.noteTasks.isFavorite) {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message: AppLocalizations.of(context)!.favorite_snackbar_noteUnmarked,
          backgroundColor: Colors.grey,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didFavoriteChange = true;
        });
        // Note now it's not favorite, if it was favorite from the start, then user did not make any changes
      } else {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message:
              AppLocalizations.of(context)!.favorite_snackbar_noteUnmarkedAgain,
          backgroundColor: Colors.grey,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didFavoriteChange = false;
        });
      }
    }
  }

  // PopupButton pick note color
  void pickNoteColorPopupButton() async {
    // Get the note color picked by the user, if no color is picked, keeps the original color
    late Color colorPickedByUser;
    NoteColor? getColorFromDialog = await showDialog<NoteColor?>(
      context: context,
      builder: (context) {
        return const NotePickColorDialog();
      },
    );
    if (getColorFromDialog != null) {
      colorPickedByUser = getColorFromDialog.getColor;
    } else {
      colorPickedByUser = NoteColorOperations.getColorFromNumber(
          colorNumber: widget.noteTasks.color);
    }

    newNote.color =
        NoteColorOperations.getNumberFromColor(color: colorPickedByUser);
    // If the colors picked by user is not the same as the current notes color, send message
    if (newNote.color != widget.noteTasks.color) {
      // Shows a snackbar with the background color selected by user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarMessage.snackBarMessage(
              message:
                  AppLocalizations.of(context)!.color_snackbar_newColorSelected,
              backgroundColor: colorPickedByUser),
        );
      }
      setState(() {
        // Changes the color of the icon to the new one
        colorIconPalette = colorPickedByUser;
        // Show the save button
        didColorChange = true;
      });
    } else {
      // User picked the same color
      setState(() {
        // Changes the color of the icon to the current note color
        didColorChange = false;
        colorIconPalette = colorPickedByUser;
        // if not null, user picked the same color, if is null, it means user did not pick any color, so dont show the snackbar
        if (getColorFromDialog != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarMessage.snackBarMessage(
                message: AppLocalizations.of(context)!
                    .color_snackbar_alreadyHaveThisColor,
                backgroundColor: colorPickedByUser),
          );
        }
      });
    }
  }
}
