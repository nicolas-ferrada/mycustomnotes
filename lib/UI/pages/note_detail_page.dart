import 'package:flutter/material.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/services/sqlite/note_database.dart';

class NoteDetail extends StatefulWidget {
  final int noteId;
  const NoteDetail({super.key, required this.noteId});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late NoteModel note;

  @override
  void initState() {
    refreshNote();
    super.initState();
  }

  refreshNote() async {
    final awaitingNote =
        await NoteDatabase.instance.readOneNoteDB(widget.noteId);
    setState(() {
      note = awaitingNote;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          initialValue: note.body,
          textAlignVertical: TextAlignVertical.top,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  void deleteNote() {
    NoteDatabase.instance.deleteNoteDB(widget.noteId);
    Navigator.pop(context);
  }
}
