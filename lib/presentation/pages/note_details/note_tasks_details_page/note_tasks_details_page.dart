import 'package:flutter/material.dart';
import '../../../../data/models/Note/note_notifier.dart';
import '../../../../data/models/Note/note_tasks_model.dart';
import '../../../../domain/services/auth_user_service.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../domain/services/note_tasks_service.dart';
import '../../../../l10n/l10n_export.dart';
import '../../../../utils/dialogs/confirmation_dialog.dart';
import '../../../../utils/dialogs/delete_note_confirmation.dart';
import '../../../../utils/dialogs/note_details_info.dart';
import '../../../../utils/dialogs/note_pick_color_dialog.dart';
import '../../../../utils/enums/menu_item_note_detail.dart';
import '../../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../../../utils/internet/check_internet_connection.dart';
import '../../../../utils/note_color/note_color.dart';
import '../../../../utils/snackbars/snackbar_message.dart';

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
  bool didTitleChanged = false;
  bool wasANewTaskAdded = false;
  bool wasATaskEditted = false;
  bool didColorChanged = false;
  bool didFavoriteChanged = false;

  // Only set state once to make the save button show
  bool didUserModifiedTaskForFirstTime = false;

  // Avoids dialog of leaving page confirmation to triggers if the save button was pressed
  bool wasTheSaveButtonPressed = false;

  // Handles the color of the favorite star icon and color palette icon
  late Color isFavoriteIconColor;
  late Color colorIconPalette;

  // New note object which is going to be modified so it can be stored later with the new data
  late NoteTasks newNote;

  // List of tasks of textformfields
  late final List<Tasks> _textFormFieldValues;

  String taskNameOnCreate = '';

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

    _textFormFieldValues = getTaskListFromMapList(newNote.tasks);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Avoids the bug of the keyboard showing for a sec
        FocusScope.of(context).unfocus();
        // Triggers when user made changes and the save button was not pressed
        bool didUserMadeChanges = (didTitleChanged ||
            wasANewTaskAdded ||
            didFavoriteChanged ||
            didColorChanged ||
            wasATaskEditted);
        if (didUserMadeChanges == true && wasTheSaveButtonPressed == false) {
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
                  didTitleChanged = true;
                });
                newNote.title = newTitleChanged.trim();
                // No changes
              } else {
                setState(() {
                  didTitleChanged = false;
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

        body: noteTasksPageBody(),
        // Save button, only visible if user changes the note
        floatingActionButton:
            noteTasksDetailsPageCreateNoteFloatingActionButton(context),
      ),
    );
  }

  ReorderableListView noteTasksPageBody() {
    final listKey = GlobalKey<AnimatedListState>();
    List<FocusNode> focusNodes =
        List.generate(_textFormFieldValues.length, (index) => FocusNode());
    FocusNode? currentFocusNode;

    void unfocusCurrentNode() {
      if (currentFocusNode != null) {
        currentFocusNode!.unfocus();
        currentFocusNode = null;
      }
    }

    return ReorderableListView.builder(
      key: listKey,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          unfocusCurrentNode();
          if (newIndex > oldIndex) newIndex--;

          // Create a new FocusNode for the TextFormField being moved
          final newFocusNode = FocusNode();

          // Delay the unfocus call to ensure the current render operation is complete
          Future.delayed(Duration.zero, () {
            // Assign focus to the new FocusNode to unfocus the old TextFormField
            FocusScope.of(context).requestFocus(newFocusNode);

            // Replace the old FocusNode with the new one
            focusNodes[oldIndex] = newFocusNode;
          });

          final item = _textFormFieldValues.removeAt(oldIndex);
          _textFormFieldValues.insert(newIndex, item);
          setState(() {
            wasATaskEditted = true;
          });
          newNote.tasks = getTextFormFieldValues();
        });
      },
      itemCount: _textFormFieldValues.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            unfocusCurrentNode();
            currentFocusNode = focusNodes[index];
            currentFocusNode!.requestFocus();
          },
          key: ValueKey(_textFormFieldValues[index]),
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            title: Row(
              children: [
                Transform.scale(
                  scale: 1.6,
                  child: Checkbox(
                    activeColor: const Color.fromRGBO(250, 216, 90, 0.9),
                    shape: const CircleBorder(),
                    value: _textFormFieldValues[index].isTaskCompleted,
                    onChanged: (value) => setState(() {
                      _textFormFieldValues[index].isTaskCompleted = value!;
                      wasATaskEditted = true;
                      newNote.tasks = getTextFormFieldValues();
                    }),
                  ),
                ),
                Expanded(
                  child: Dismissible(
                    onDismissed: (direction) {
                      setState(() {
                        _textFormFieldValues.removeAt(index);
                        wasATaskEditted = true;
                        newNote.tasks = getTextFormFieldValues();
                      });
                    },
                    background: Container(
                      color: Colors.redAccent,
                      child: const Icon(Icons.delete),
                    ),
                    key: ValueKey(_textFormFieldValues[index]),
                    child: ReorderableDelayedDragStartListener(
                      index: index,
                      key: UniqueKey(),
                      child: StatefulBuilder(
                        builder: (context, setStatee) {
                          return TextFormField(
                            maxLines: null,
                            initialValue: _textFormFieldValues[index].taskName,
                            onChanged: (value) {
                              setStatee(() {
                                wasATaskEditted = true;
                                _textFormFieldValues[index].taskName = value;
                                newNote.tasks = getTextFormFieldValues();
                              });
                            },
                            focusNode: focusNodes[index],
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(28),
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Column noteTasksDetailsPageCreateNoteFloatingActionButton(
      BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: null,
          tooltip: 'Edit the note',
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
        const SizedBox(
          height: 8,
        ),
        FloatingActionButton.extended(
          heroTag: null,
          tooltip: 'Add a new task',
          onPressed: () async {
            showModalBottomSheet(
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
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    taskNameOnCreate = value.trim();
                                  });
                                },
                                onSubmitted: (_) {
                                  if (taskNameOnCreate.isNotEmpty) {
                                    addNewTask();
                                    taskNameOnCreate = ''; // restart text value
                                    Navigator.pop(context);
                                    setState(() {
                                      wasANewTaskAdded = true;
                                      newNote.tasks = getTextFormFieldValues();
                                    });

                                    FocusScope.of(context).unfocus();
                                  } else {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBarMessage.snackBarMessage(
                                          message:
                                              "You can't create an empty task",
                                          backgroundColor: Colors.red),
                                    );
                                    FocusScope.of(context).unfocus();
                                  }
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
                              if (taskNameOnCreate.isNotEmpty) {
                                addNewTask();
                                taskNameOnCreate = ''; // restart text value
                                Navigator.pop(context);
                                setState(() {
                                  wasANewTaskAdded = true;
                                  newNote.tasks = getTextFormFieldValues();
                                });
                                FocusScope.of(context).unfocus();
                              } else {
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBarMessage.snackBarMessage(
                                      message: "You can't create an empty task",
                                      backgroundColor: Colors.red),
                                );
                                FocusScope.of(context).unfocus();
                              }
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
          icon: const Icon(Icons.add),
          label: const Text('New task'),
        ),
      ],
    );
  }

  void addNewTask() {
    setState(() {
      _textFormFieldValues
          .add(Tasks(isTaskCompleted: false, taskName: taskNameOnCreate));
    });
  }

  List<Map<String, dynamic>> getTextFormFieldValues() {
    return _textFormFieldValues
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
          DeleteNoteConfirmation.deleteNoteDialog(
              context: context, note: widget.noteTasks);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: MenuItemNoteDetail.item1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // If it's favorite, show yellow icon, if not, white
              Icon(
                Icons.star,
                color: isFavoriteIconColor,
                size: 28,
              ),
              const Text('Favorite'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.palette,
                size: 28,
                color: colorIconPalette,
              ),
              const Text('Color'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: MenuItemNoteDetail.item4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.share, size: 28),
              Text('Share'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: MenuItemNoteDetail.item5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.info, size: 28),
              Text('Details'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: MenuItemNoteDetail.item6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.delete, size: 28),
              Text('Delete'),
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
          didFavoriteChanged = false;
        });
        // Note now it's favorite, but it wasn't from the start, so user made a change
      } else {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message: AppLocalizations.of(context)!.favorite_snackbar_noteMarked,
          backgroundColor: Colors.amber.shade300,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didFavoriteChanged = true;
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
          didFavoriteChanged = true;
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
          didFavoriteChanged = false;
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
              message: "New color selected to be applied",
              backgroundColor: colorPickedByUser),
        );
      }
      setState(() {
        // Changes the color of the icon to the new one
        colorIconPalette = colorPickedByUser;
        // Show the save button
        didColorChanged = true;
      });
    } else {
      // User picked the same color
      setState(() {
        // Changes the color of the icon to the current note color
        didColorChanged = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarMessage.snackBarMessage(
              message: "Your note already have this color",
              backgroundColor: colorPickedByUser),
        );
      });
    }
  }
}
