import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/exceptions/exceptions_alert_dialog.dart';
import 'package:mycustomnotes/services/note_service.dart';

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
            const SizedBox(height: 30),
            // Button to create a note
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
                minimumSize: const Size(200, 75),
                elevation: 30,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () async {
                // Create note button
                try {
                  // Create a note on firebase
                  await NoteService.createNoteFirestore(
                    title: _noteTitleController.text,
                    body: _noteBodyController.text,
                    userId: user.uid,
                  ).then((_) {
                    Navigator.maybePop(context);
                  });
                } catch (errorMessage) {
                  ExceptionsAlertDialog.showErrorDialog(
                      context, errorMessage.toString());
                }
              },
              child: const Text(
                'Create a new note',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
