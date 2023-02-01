import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/create_note_page.dart';
import 'package:mycustomnotes/UI/pages/note_detail_page.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/database/sqlite/database_helper.dart';
import 'package:mycustomnotes/services/AuthUserService.dart';
import 'package:mycustomnotes/widgets/notes_widget.dart';

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

  Future refreshNotes() async {
    setState(() {
      areNotesLoading = true;
    });
    await DatabaseHelper.instance
        .readAllNotesDB(user.uid)
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
            // Log out dialog
            logOutDialog(context);
          },
        ),
      ),
      // Body to show the notes
      body: Center(
          child: areNotesLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text('No notes to show')
                  // Show all notes of the user in screen
                  : buildNotes()),
      // Button to create a new note
      floatingActionButton: newNoteButton(context),
    );
  }

  // Log out dialog
  Future<dynamic> logOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Color.fromRGBO(250, 216, 90, 0.8),
          title: const Center(
            child: Text('Log out'),
          ),
          content: Text(
            'Do you really want to log out?',
            style: const TextStyle(color: Colors.white),
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
                      await AuthUserService.logOutUserFirebase(context)
                          .then((value) => Navigator.of(context).pop());
                    },
                    child: const Text(
                      'Log out',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Create a new note button
  FloatingActionButton newNoteButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Color.fromRGBO(250, 216, 90, 0.9),
      label: const Text('New note'),
      icon: const Icon(Icons.create),
      onPressed: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => const CreateNote(),
              ),
            )
            .then((_) => refreshNotes());
      },
    );
  }

  // Show all the notes of the user in the screen
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
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                          builder: (context) => NoteDetail(noteId: note.id!)),
                    )
                    .then((_) => refreshNotes());
              },
              child: NotesWidget(note: note, index: index));
        }),
      ),
    );
  }
}
