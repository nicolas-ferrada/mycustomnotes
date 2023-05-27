import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../../../data/models/Note/note_notifier.dart';
import '../../../domain/services/auth_user_service.dart';

import 'package:provider/provider.dart';
import '../../../domain/services/note_tasks_service.dart';
import '../../../l10n/l10n_export.dart';
import '../../../utils/dialogs/note_pick_color_dialog.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../../utils/internet/check_internet_connection.dart';
import '../../../utils/note_color/note_color.dart';
import '../../../utils/snackbars/snackbar_message.dart';
import 'package:audioplayers/audioplayers.dart';

class Tasks {
  bool isTaskCompleted;
  String taskName;

  Tasks({
    required this.isTaskCompleted,
    required this.taskName,
  });
}

class NoteTasksCreatePage extends StatefulWidget {
  const NoteTasksCreatePage({super.key});

  @override
  State<NoteTasksCreatePage> createState() => _NoteTasksCreatePageState();
}

class _NoteTasksCreatePageState extends State<NoteTasksCreatePage> {
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
  Color isFavoriteIconColor = Colors.grey;
  Color colorIconPalette = Colors.grey;

  final List<Tasks> tasksList = [];
  final List<Tasks> notCompletedTasksList = [];
  final List<Tasks> completedTasksList = [];

  // if false, completed notes will dissapear and the arrow icon will point to the right
  bool areCompletedNotesVisible = true;

  // Note title controller
  final TextEditingController _titleTextController = TextEditingController();

  // New task controller
  final TextEditingController _newTaskTextController = TextEditingController();

  // Keyboard stream suscription used to react to keyboard dismiss changes
  late StreamSubscription<bool> keyboardSubscription;

  // Used to do not execute the Navigator.maybePop(context) when the title keyboard is closed
  final FocusNode noteTitleTextFormFieldFocusNode = FocusNode();

  // Used to do request focus on textformfield new task submitted
  final FocusNode noteTaskSubmittedFieldFocusNode = FocusNode();

  // Used to close them tapping backbutton once.
  bool isShowModalBottomSheetTryingToBeClosed = false;
  bool isADialogTaskTryingTobeClosed = false;

  bool isNoteFavorite = false;

  int intNoteColor = 0;

  Color noteColorPaletteIcon = Colors.grey;
  Color noteColorFavoriteIcon = Colors.grey;

  @override
  void initState() {
    super.initState();
    keyboardDismissSubscription();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    noteTitleTextFormFieldFocusNode.dispose();
    noteTaskSubmittedFieldFocusNode.dispose();
    super.dispose();
  }

  // Do actions on keyboard dismiss, used to close tasks dialog when editing a note and to
  // close the showModalBottomSheet on one back button tap instead of two.
  // Since one tap will only close the keyboard, and the second it will close it entirely,
  // the idea is to make both things in one backbutton tap.
  void keyboardDismissSubscription() {
    var keyboardController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardController.onChange.listen((bool isKeyboardOpen) {
      // If the keyboard closes after modalbuttonsheet was pressed,
      // one tap on the back button will close it.
      if (!isKeyboardOpen && isShowModalBottomSheetTryingToBeClosed) {
        Navigator.maybePop(context);
        isShowModalBottomSheetTryingToBeClosed = false;
        // If the keyboard closes after a completed/not compled task was pressed,
        // one tap on the back button will close it.
      } else if (!isKeyboardOpen && isADialogTaskTryingTobeClosed) {
        Navigator.maybePop(context);
        isADialogTaskTryingTobeClosed = false;
      }
    });
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

  // Used to save all the notes in a List of Maps to the db
  List<Map<String, dynamic>> getListMapFromTasksList() {
    final List<Tasks> finalTasksList = getFinalTasksList();

    List<Map<String, dynamic>> finalTasksListMap = [];

    for (int i = 0; i < finalTasksList.length; i++) {
      Map<String, dynamic> map = {
        'taskName': finalTasksList[i].taskName,
        'isTaskCompleted': finalTasksList[i].isTaskCompleted,
      };
      finalTasksListMap.add(map);
    }
    return finalTasksListMap;
  }

  // Combine not completed tasks and completed tasks
  List<Tasks> getFinalTasksList() {
    final List<Tasks> finalTasksList = [
      ...notCompletedTasksList,
      ...completedTasksList
    ];
    return finalTasksList;
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
    return Scaffold(
      // Note's title, favorite and pick color icons
      appBar: AppBar(
        title: TextFormField(
          textCapitalization: TextCapitalization.sentences,
          controller: _titleTextController,
          onChanged: (value) {
            setState(() {
              didTitleChange = true;
              didUserModifiedTaskForFirstTime = true;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppLocalizations.of(context)!
                .titleInput_textformfield_noteTextCreatePage,
            hintStyle: const TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 2),
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    late Color newColor;
                    NoteColor? getColorFromDialog =
                        await showDialog<NoteColor?>(
                      context: context,
                      builder: (context) {
                        return const NotePickColorDialog();
                      },
                    );
                    if (getColorFromDialog != null) {
                      newColor = getColorFromDialog.getColor;
                    } else {
                      newColor = NoteColorOperations.getColorFromNumber(
                          colorNumber: intNoteColor);
                    }
                    // Difine the note color
                    intNoteColor =
                        NoteColorOperations.getNumberFromColor(color: newColor);
                    setState(() {
                      noteColorPaletteIcon = newColor;
                    });
                  },
                  icon: Icon(
                    Icons.palette,
                    color: noteColorPaletteIcon,
                    size: 28,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.star,
                    color: noteColorFavoriteIcon,
                    size: 28,
                  ),
                  onPressed: () {
                    if (!isNoteFavorite) {
                      // It was not favorite, now it is
                      setState(() {
                        noteColorFavoriteIcon = Colors.amberAccent;
                      });
                      isNoteFavorite = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBarMessage.snackBarMessage(
                              message: AppLocalizations.of(context)!
                                  .favorite_snackbar_noteMarked,
                              backgroundColor: Colors.amberAccent));
                    } else {
                      // It was favorite, now it is not
                      setState(() {
                        noteColorFavoriteIcon = Colors.grey;
                      });
                      isNoteFavorite = false;
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: (getFinalTasksList().isNotEmpty)
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tasks not completed
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ReorderableListView.builder(
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: notCompletedTasksList.length,
                      itemBuilder: (context, index) {
                        final task = notCompletedTasksList[index];

                        return buildTasksNotCompleted(index: index, task: task);
                      },
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          final index =
                              (newIndex > oldIndex) ? newIndex - 1 : newIndex;
                          final task = notCompletedTasksList.removeAt(oldIndex);
                          notCompletedTasksList.insert(index, task);
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
                      child: Visibility(
                        visible: completedTasksList.isNotEmpty,
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
                              Text(
                                AppLocalizations.of(context)!
                                    .noteTasks_text_tabTasksCompleted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: areCompletedNotesVisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListView.builder(
                        reverse: true,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: completedTasksList.length,
                        itemBuilder: (context, index) {
                          final task = completedTasksList[index];
                          return buildTasksCompleted(index: index, task: task);
                        },
                      ),
                    ),
                  ),
                  // Let space if the icons obstruct vision to the task and
                  // for not losing the tasks completed tab when it's opened
                  SizedBox(
                    height: completedTasksList.isNotEmpty ? 128 : 96,
                  ),
                ],
              ),
            )
          : Center(
              child: Text(
                AppLocalizations.of(context)!.noteTasks_text_noTasksAdded,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
      // Save button, only visible if user changes the note
      floatingActionButton:
          noteTasksDetailsPageCreateNoteFloatingActionButton(context),
    );
  }

  Widget buildTasksNotCompleted({
    required int index,
    required Tasks task,
  }) {
    return Padding(
      // Make each tile unique
      key: ValueKey(task),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Dismissible(
        key: ValueKey(task),
        onDismissed: (_) {
          setState(() {
            notCompletedTasksList.removeAt(index);
            didTaskChange = true;
          });
        },
        background: Container(
          color: Colors.redAccent,
          child: const Icon(Icons.delete),
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.white24,
          ),
          // If the color is in the ListTile, a visual bug happens on dragging tasks
          child: ListTile(
            onTap: () {
              isADialogTaskTryingTobeClosed = true;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                        Navigator.maybePop(context);
                      },
                      autofocus: true,
                      initialValue: task.taskName,
                      // Task modification
                      onChanged: (value) => setState(
                        () {
                          task.taskName = value;
                          didTaskChange = true;
                        },
                      ),
                    ),
                  );
                },
              ).then((_) {
                // This is when the dialog is dismissed by tapping outside,
                // this code will come first than keyboardListener and it will avoid double navigator.pop
                isADialogTaskTryingTobeClosed = false;
              });
            },
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
                    // add to the other list and remove it from this
                    completedTasksList.add(notCompletedTasksList[index]);
                    notCompletedTasksList.removeAt(index);

                    didTaskChange = true;
                  });
                  // Sound when a task is completed
                  AudioPlayer audioPlayer = AudioPlayer();
                  const completedTaskSound = "completedTask.mp3";
                  audioPlayer
                      .setSource(AssetSource(completedTaskSound))
                      .then((value) {
                    audioPlayer.play(AssetSource(completedTaskSound));
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
  }

  Widget buildTasksCompleted({
    required int index,
    required Tasks task,
  }) {
    return Padding(
      // Make each tile unique
      key: ValueKey(task),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Dismissible(
        key: ValueKey(task),
        onDismissed: (direction) {
          setState(() {
            completedTasksList.removeAt(index);
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
              isADialogTaskTryingTobeClosed = true;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      autofocus: true,
                      initialValue: task.taskName,
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                        Navigator.maybePop(context);
                      },
                      // Task modification
                      onChanged: (value) => setState(
                        () {
                          task.taskName = value;
                          didTaskChange = true;
                        },
                      ),
                    ),
                  );
                },
              ).then((_) {
                // This is when the dialog is dismissed by tapping outside,
                // this code will come first than keyboardListener and it will avoid double navigator.pop
                isADialogTaskTryingTobeClosed = false;
              });
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
                onChanged: (value) async {
                  setState(() {
                    task.isTaskCompleted = value!;
                    // add to the other list and remove it from this
                    notCompletedTasksList.add(completedTasksList[index]);
                    completedTasksList.removeAt(index);

                    didTaskChange = true;
                  });
                },
              ),
            ),
            // Task name
            title: Text(
              task.taskName,
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ),
      ),
    );
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
          child: FloatingActionButton.extended(
            heroTag: null,
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
                if (context.mounted) {
                  await NoteTasksService.createNoteTasks(
                    context: context,
                    title: _titleTextController.text,
                    isFavorite: isNoteFavorite,
                    color: intNoteColor,
                    tasks: getListMapFromTasksList(),
                    userId: currentUser.uid,
                  ).timeout(
                    Duration(seconds: waitingConnection),
                    onTimeout: () {
                      Provider.of<NoteNotifier>(context, listen: false)
                          .refreshNotes();

                      Navigator.of(context).maybePop();
                    },
                  );
                }
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
            icon: const Icon(Icons.save),
            label: Text(
                AppLocalizations.of(context)!.save_button_noteTextCreatePage),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        FloatingActionButton.extended(
          heroTag: null,
          onPressed: () async {
            isShowModalBottomSheetTryingToBeClosed = true;
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(),
              context: context,
              isDismissible: true,
              builder: (BuildContext context) {
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
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: noteTaskSubmittedFieldFocusNode,
                            controller: _newTaskTextController,
                            autofocus: true,
                            onSubmitted: (_) {
                              creatingNewTask();
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!
                                  .noteTasks_textformfield_createNewTask,
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
            ).then((_) {
              // This is when the dialog is dismissed by tapping outside,
              // this code will come first than keyboardListener and it will avoid double navigator.pop
              isShowModalBottomSheetTryingToBeClosed = false;
            });
          },
          backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
          icon: const Icon(Icons.add),
          label: Text(AppLocalizations.of(context)!.noteTasks_button_newTask),
        ),
      ],
    );
  }

  void creatingNewTask() {
    if (_newTaskTextController.text.isNotEmpty) {
      setState(() {
        didTaskChange = true;
        addNewTask();
        _newTaskTextController.clear(); // restart text value
        noteTaskSubmittedFieldFocusNode.requestFocus();
      });
    } else {
      // task is empty
      FocusManager.instance.primaryFocus?.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarMessage.snackBarMessage(
            message: AppLocalizations.of(context)!.noteTasks_snackbar_emptyTask,
            backgroundColor: Colors.red),
      );
    }
  }

  void addNewTask() {
    notCompletedTasksList.add(
        Tasks(isTaskCompleted: false, taskName: _newTaskTextController.text));
  }
}
