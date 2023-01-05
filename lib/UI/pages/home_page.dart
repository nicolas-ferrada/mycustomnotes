import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/create_note_page.dart';
import 'package:mycustomnotes/UI/pages/note_detail_page.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/database/sqlite/database_helper.dart';
import 'package:mycustomnotes/widgets/notes_widget.dart';
import '../../auth_functions/auth_firebase_functions.dart';

import 'dart:developer' as dev;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late List<Note> notes;
  bool areNotesLoading = false;

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  void dispose() {
    DatabaseHelper.instance.closeDB();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() {
      areNotesLoading = true;
    });

    await DatabaseHelper.instance
        .readAllNotesDB()
        .then((inComingNotes) => setState((() {
              notes = inComingNotes;
            })));

    setState(() {
      areNotesLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Welcome: ${user.email}',
          style: const TextStyle(fontSize: 14),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await AuthFirebaseFunctions.logoutFirebase();
          },
        ),
      ),
      // Body to show the notes
      body: Center(
          child: areNotesLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text('No notes to show')
                  : buildNotes()),
      // Button create a new note page
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amberAccent,
        label: const Text('New note'),
        icon: const Icon(Icons.create),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateNote(),
            ),
          ).then((_) => refreshNotes());
        },
      ),
    );
  }

  Widget buildNotes() {
    return GridView.custom(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: notes.length,
        ((context, index) {
          Note note = notes[index];
          return GestureDetector(
              onTap: () {
                // ACTUALIZAR UI AL VOLVER DE UNA NOTA
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => NoteDetail(noteId: note.id!)),
                ).then((_) => refreshNotes());
              },
              child: NotesWidget(note: note, index: index));
        }),
      ),
    );
  }
}
