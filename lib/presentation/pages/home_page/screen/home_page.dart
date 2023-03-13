import 'package:flutter/material.dart';
import 'package:mycustomnotes/data/models/Note/note_model.dart';
import 'package:mycustomnotes/domain/services/auth_user_service.dart';
import 'package:mycustomnotes/domain/services/note_service.dart';
import 'package:mycustomnotes/presentation/pages/home_page/widgets/home_page_build_notes_widget.dart';
import 'package:mycustomnotes/utils/dialogs/confirmation_dialog.dart';

import '../widgets/home_page_new_note_button_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = AuthUserService.getCurrentUserFirebase(); // init state?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${currentUser.email}',
          style: const TextStyle(fontSize: 16),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Transform.scale(
            scaleX: -1,
            child: const Icon(
              Icons.logout,
              size: 26,
            ),
          ),
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
                    : HomePageBuildNotesWidget(
                        notesList: notes,
                      ), // Show all notes of the user in screen
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      // Button to create a new note
      floatingActionButton: newNoteButton(context),
    );
  }
}
