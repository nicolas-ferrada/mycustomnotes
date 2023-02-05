import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/exceptions/exceptions_alert_dialog.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/services/note_service.dart';

class NoteDetail extends StatefulWidget {
  final String noteId;
  const NoteDetail({super.key, required this.noteId});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final user = FirebaseAuth.instance.currentUser!;
  bool _isSaveButtonVisible = false;
  late String newTitle;
  late String newBody;
  late Note note;

  @override
  void initState() {
    super.initState();
    updateTitleBody();
  }

  // Show the title and the body on note detail
  updateTitleBody() async {
    try {
      await NoteService.readOneNoteFirestore(noteId: widget.noteId)
          .then((noteFromDB) {
        setState(() {
          note = noteFromDB;
          newTitle = note.title;
          newBody = note.body;
        });
      });
    } catch (errorMessage) {
      ExceptionsAlertDialog.showErrorDialog(context, errorMessage.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NoteService.readOneNoteFirestore(noteId: widget.noteId),
      builder: (context, snapshot) {
        // If one note was returned
        if (snapshot.hasData) {
          note = snapshot.data!;
          return Scaffold(
            // Note's title
            appBar: AppBar(
              actions: [
                // Delete note
                deleteNoteIconButton(context),
              ],
              title: TextFormField(
                initialValue: note.title,
                onChanged: (value) {
                  setState(() {
                    // Used to edit the note
                    _isSaveButtonVisible = true;
                    newTitle = value;
                  });
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
            // Note's body
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    // Used to edit the note
                    _isSaveButtonVisible = true;
                    newBody = value;
                  });
                },
                initialValue: note.body,
                textAlignVertical: TextAlignVertical.top,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            // Save button, only visible if user changes the note
            floatingActionButton: Visibility(
              visible: _isSaveButtonVisible,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.amberAccent,
                label: const Text(
                  'Save\nchanges',
                  style: TextStyle(fontSize: 12),
                ),
                icon: const Icon(Icons.save),
                onPressed: () {
                  // Edit the selected note
                  try {
                    NoteService.editOneNoteFirestore(
                      title: newTitle,
                      body: newBody,
                      noteId: widget.noteId,
                      userId: user.uid,
                      // need to update ids?
                    ).then((_) => Navigator.maybePop(context));
                  } catch (errorMessage) {
                    ExceptionsAlertDialog.showErrorDialog(
                        context, errorMessage.toString());
                  }
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error has ocurred'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Delete note button (icon)
  IconButton deleteNoteIconButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        try {
          showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  elevation: 3,
                  backgroundColor: const Color.fromARGB(220, 250, 215, 90),
                  title: const Center(
                    child: Text('Confirmation'),
                  ),
                  content: const Text(
                    'Do you really want to permanently delete this note?',
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    Center(
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 40),
                                backgroundColor: Colors.white),
                            onPressed: () async {
                              // log out firebase
                              try {
                                // Delete a specified note
                                Navigator.pop(context);
                                await NoteService.deleteOneNoteFirestore(
                                        noteId: widget.noteId)
                                    .then((_) => Navigator.maybePop(context));
                              } catch (errorMessage) {
                                ExceptionsAlertDialog.showErrorDialog(
                                    context, errorMessage.toString());
                              }
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 40),
                                backgroundColor: Colors.white),
                            onPressed: () {
                              Navigator.maybePop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                );
              });
        } catch (errorMessage) {
          ExceptionsAlertDialog.showErrorDialog(
              context, errorMessage.toString());
        }
      },
      icon: const Icon(Icons.delete),
    );
  }
}
