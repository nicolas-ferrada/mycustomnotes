import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/exceptions/exceptions_alert_dialog.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/database/sqlite/local_database_helper.dart';
import 'package:mycustomnotes/services/note_service.dart';

class NoteDetail extends StatefulWidget {
  final int noteId;
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
    bringNoteDB();
    super.initState();
  }

  // Read one note from sqlite and applies it to the late variable note here.
  bringNoteDB() async {
    try {
      await NoteService.readOneNoteDB(noteId: widget.noteId).then((noteFromDB) {
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
      future: LocalDatabaseHelper.instance.readOneNoteDB(widget.noteId),
      builder: (context, snapshot) {
        // If one nota was returned
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
                  try {
                    NoteService.editNote(
                      title: newTitle,
                      body: newBody,
                      id: widget.noteId,
                      userId: user.uid,
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
          return const Text('An error has ocurred');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  // Delete note button (icon)
  IconButton deleteNoteIconButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        try {
          NoteService.deleteNote(noteId: widget.noteId)
              .then((_) => Navigator.maybePop(context));
        } catch (errorMessage) {
          ExceptionsAlertDialog.showErrorDialog(
              context, errorMessage.toString());
        }
      },
      icon: const Icon(Icons.delete),
    );
  }
}
