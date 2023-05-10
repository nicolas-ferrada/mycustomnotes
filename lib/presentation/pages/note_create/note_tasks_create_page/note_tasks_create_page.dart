import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/Note/note_notifier.dart';
import '../../../../domain/services/auth_user_service.dart';
import '../../../../domain/services/note_tasks_service.dart';
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

class NoteTasksCreatePage extends StatefulWidget {
  const NoteTasksCreatePage({super.key});

  @override
  State<NoteTasksCreatePage> createState() => _NoteTasksCreatePageState();
}

class _NoteTasksCreatePageState extends State<NoteTasksCreatePage> {
  final currentUser = AuthUserService.getCurrentUserFirebase();

  final _noteTitleController = TextEditingController();

  final List<Tasks> _textFormFieldValues = [];

  bool isNoteFavorite = false;

  bool _isCreateButtonVisible = false;

  int intNoteColor = 0;

  Color noteColorPaletteIcon = Colors.grey;
  Color noteColorFavoriteIcon = Colors.grey;

  String taskNameOnCreate = '';

  @override
  void dispose() {
    _noteTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Note's title, favorite and pick color icons
      appBar: AppBar(
        title: TextFormField(
          controller: _noteTitleController,
          onChanged: (value) {
            setState(() {
              _isCreateButtonVisible = true;
            });
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Title",
            hintStyle: TextStyle(color: Colors.white70),
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
                    Color? getColorFromDialog =
                        await NoteColorOperations.pickNoteColorDialog(
                            context: context);
                    if (getColorFromDialog != null) {
                      newColor = getColorFromDialog;
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
                              message: 'Note marked as favorite',
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
      // Note's body
      body: noteCreatePageBody(),
      // Save button, only visible if user changes the note
      floatingActionButton: noteCreatePageFloatingActionButton(context),
    );
  }

  ReorderableListView noteCreatePageBody() {
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
                    }),
                  ),
                ),
                Expanded(
                  child: Dismissible(
                    onDismissed: (direction) {
                      setState(() {
                        _textFormFieldValues.removeAt(index);
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
                      child: StatefulBuilder(builder: (context, setState) {
                        return TextFormField(
                          maxLines: null,
                          initialValue: _textFormFieldValues[index].taskName,
                          onChanged: (value) => setState(() =>
                              _textFormFieldValues[index].taskName = value),
                          focusNode: focusNodes[index],
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(28),
                            border: OutlineInputBorder(),
                          ),
                        );
                      }),
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

  Column noteCreatePageFloatingActionButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: _isCreateButtonVisible,
          child: FloatingActionButton.extended(
            heroTag: null,
            tooltip: 'Create the note',
            onPressed: () async {
              // Create note button
              try {
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
                await NoteTasksService.createNoteTasks(
                  title: _noteTitleController.text,
                  tasks: getTextFormFieldValues(),
                  userId: currentUser.uid,
                  isFavorite: isNoteFavorite,
                  color: intNoteColor,
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
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
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
                                    _isCreateButtonVisible = true;
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
                                _isCreateButtonVisible = true;
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
}
