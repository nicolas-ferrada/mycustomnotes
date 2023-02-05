import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/create_note.dart';
import 'package:mycustomnotes/UI/pages/note_detail_edit_delete.dart';
import 'package:mycustomnotes/exceptions/exceptions_alert_dialog.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/services/auth_user_service.dart';
import 'package:mycustomnotes/services/note_service.dart';
import 'package:mycustomnotes/UI/widgets/notes_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  void _updateNotes() {
    setState(() {});
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
      body: StreamBuilder(
          stream: NoteService.readAllNotesFirestore(userId: user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            } else if (snapshot.hasData) {
              final List<Note> notes = snapshot.data!;
              // ordered by date
              // notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              return Center(
                  child: notes.isEmpty
                      ? const Text('No notes to show')
                      // Show all notes of the user in screen
                      : buildNotes(notes));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
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
          backgroundColor: const Color.fromRGBO(250, 216, 90, 0.8),
          title: const Center(
            child: Text('Log out'),
          ),
          content: const Text(
            'Do you really want to log out?',
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
                        await AuthUserService.logOutUserFirebase()
                            .then((value) => Navigator.maybePop(context));
                      } catch (errorMessage) {
                        ExceptionsAlertDialog.showErrorDialog(
                            context, errorMessage.toString());
                      }
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
                  const SizedBox(
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
      backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
      label: const Text('New note'),
      icon: const Icon(Icons.create),
      onPressed: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => const CreateNote(),
              ),
            )
            .then((_) => _updateNotes());
      },
    );
  }

  // Show all the notes of the user in the screen
  Widget buildNotes(List<Note> notes) {
    return GridView.custom(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        childCount: notes.length,
        ((context, index) {
          Note note = notes[index];
          // Tapping on a note, opens the detailed version of it
          return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => NoteDetail(noteId: note.id)))
                    .then((value) => _updateNotes());
              },
              child: NotesWidget(note: note, index: index));
        }),
      ),
    );
  }
}
