import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/database/sqlite/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final int noteId;
  const NoteDetail({super.key, required this.noteId});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final user = FirebaseAuth.instance.currentUser!;
  bool _isSaveButtonVisible = false;
  String newTitle = '';
  String newBody = '';
  late Note note;

  @override
  void initState() {
    refreshNote();
    super.initState();
  }

  refreshNote() async {
    await DatabaseHelper.instance
        .readOneNoteDB(widget.noteId)
        .then((awaitingNote) => setState(() {
              note = awaitingNote;
              newTitle = note.title;
              newBody = note.body;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseHelper.instance.readOneNoteDB(widget.noteId),
        builder: (context, snapshot) {
          // If one nota was returned
          if (snapshot.hasData) {
            note = snapshot.data!;
            return Scaffold(
              // Note's title
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      deleteNote();
                    },
                    icon: const Icon(Icons.delete),
                  )
                ],
                title: TextFormField(
                  initialValue: note.title,
                  onChanged: (value) {
                    setState(() {
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
                    editNote();
                  },
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('An error has ocurred');
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  void deleteNote() {
    DatabaseHelper.instance.deleteNoteDB(widget.noteId);
    Navigator.pop(context);
  }

  void editNote() {
    final newNote = Note(
        title: newTitle, body: newBody, id: widget.noteId, userId: user.uid);
    DatabaseHelper.instance.editNoteDB(newNote);

    Navigator.pop(context);
  }
}
