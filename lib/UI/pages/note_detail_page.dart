import 'package:flutter/material.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/services/sqlite/note_database.dart';
import 'dart:developer' as logs show log;

class NoteDetail extends StatefulWidget {
  final int noteId;
  const NoteDetail({super.key, required this.noteId});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late Note note;
  bool _isSaveButtonVisible = false;
  String newTitle = '';
  String newBody = '';

  @override
  void initState() {
    logs.log('init state');
    refreshNote();
    super.initState();
  }

  refreshNote() async {
    final awaitingNote =
        await NoteDatabase.instance.readOneNoteDB(widget.noteId);
    setState(() {
      note = awaitingNote;
      newTitle = note.title;
      newBody = note.body;
    });
  }

  @override
  Widget build(BuildContext context) {
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
  }

  void deleteNote() {
    NoteDatabase.instance.deleteNoteDB(widget.noteId);
    Navigator.pop(context);
  }

  void editNote() {
    final newNote = Note(title: newTitle, body: newBody, id: widget.noteId);
    NoteDatabase.instance.editNoteDB(newNote);

    Navigator.pop(context);
  }
}
