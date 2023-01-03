import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/services/sqlite/note_database.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final user = FirebaseAuth.instance.currentUser!;
  final _noteTitleController = TextEditingController();
  final _noteBodyController = TextEditingController();

  @override
  void dispose() {
    _noteTitleController.dispose();
    _noteBodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Creating a note'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Note's title
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _noteTitleController,
                    decoration: const InputDecoration(
                      hintText: "Enter your note's title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Note's body
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _noteBodyController,
                    decoration: const InputDecoration(
                      hintText: "Enter your note's body",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            // Button create a note
            ElevatedButton(
              onPressed: () {
                createNoteDB();
              },
              child: const Text('Create a note'),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  createNoteDB() {
    final note =
        Note(title: _noteTitleController.text, body: _noteBodyController.text);

    NoteDatabase.instance.createNoteDB(note);

    Navigator.pop(context);
  }
}
