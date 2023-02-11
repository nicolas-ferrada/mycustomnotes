import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/create_note.dart';
import 'package:mycustomnotes/UI/pages/note_detail_edit_delete.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/services/auth_user_service.dart';
import 'package:mycustomnotes/services/note_service.dart';
import 'package:mycustomnotes/UI/widgets/notes_widget.dart';
import 'package:mycustomnotes/utils/dialogs/confirmation_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = AuthUserService.getCurrentUserFirebase(); // init state?

  void _updateNotes() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Text(
              'Welcome: ${currentUser.email}',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            // Log out dialog
            ConfirmationDialog.logOutDialog(context);
          },
        ),
      ),
      // Body to show the notes
      body: StreamBuilder(
          stream: NoteService.readAllNotesFirestore(userId: currentUser.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong ${snapshot.error.toString()}');
            } else if (snapshot.hasData) {
              final List<Note> notes = snapshot.data!;
              return Center(
                // If notes are empty, show 'no notes message', if theres notes, build them
                child: notes.isEmpty
                    ? const Text('No notes to show')
                    : buildNotes(notes), // Show all notes of the user in screen
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      // Button to create a new note
      floatingActionButton: newNoteButton(context),
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
          // ordered by date, first note created will show first
          notes.sort((a, b) => a.createdDate.compareTo(b.createdDate));
          // put favorites first using a custom boolean compare
          notes.sort((a, b) => compareBooleans(a.isFavorite, b.isFavorite));
          Note note = notes[index];
          // Tapping on a note, opens the detailed version of it
          return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => NoteDetail(noteId: note.id)))
                    .then((_) => _updateNotes());
              },
              child: NotesWidget(
                note: note,
                lastModificationDate: note.lastModificationDate,
                index: index,
                isFavorite: note.isFavorite,
              ));
        }),
      ),
    );
  }

  int compareBooleans(bool a, bool b) {
    if (a == b) {
      return 0;
    }
    return a ? -1 : 1;
  }
}
