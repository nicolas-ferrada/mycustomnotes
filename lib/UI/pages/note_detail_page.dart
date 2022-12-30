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
    return Text('${note.body}, ${note.title}');
  }
}
