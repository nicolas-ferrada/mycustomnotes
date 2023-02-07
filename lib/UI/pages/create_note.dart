import 'package:flutter/material.dart';
import 'package:mycustomnotes/exceptions/exceptions_alert_dialog.dart';
import 'package:mycustomnotes/services/auth_user_service.dart';
import 'package:mycustomnotes/services/note_service.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final currentUser = AuthUserService.getCurrentUserFirebase();
  final _noteTitleController = TextEditingController();
  final _noteBodyController = TextEditingController();
  bool isFavorite = false;
  bool _isCreateButtonVisible = false;

  @override
  void dispose() {
    _noteTitleController.dispose();
    _noteBodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Note's title
      appBar: AppBar(
        actions: const [
          // Note options before creating
        ],
        title: TextFormField(
          controller: _noteTitleController,
          onChanged: (value) {
            setState(() {
              _isCreateButtonVisible = true;
            });
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Enter your note's title",
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      // Note's body
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          onChanged: (value) {
            setState(() {
              _isCreateButtonVisible = true;
            });
          },
          controller: _noteBodyController,
          textAlignVertical: TextAlignVertical.top,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(
            hintText: "Enter your note's body",
            border: InputBorder.none,
          ),
        ),
      ),
      // Save button, only visible if user changes the note
      floatingActionButton: Visibility(
        visible: _isCreateButtonVisible,
        child: FloatingActionButton.extended(
          onPressed: () async {
            // Create note button
            try {
              // Create a note on firebase
              await NoteService.createNoteFirestore(
                title: _noteTitleController.text,
                body: _noteBodyController.text,
                userId: currentUser.uid,
                isFavorite: false,
              ).then((_) {
                Navigator.maybePop(context);
              });
            } catch (errorMessage) {
              ExceptionsAlertDialog.showErrorDialog(
                  context, errorMessage.toString());
            }
          },
          backgroundColor: Colors.amberAccent,
          label: const Text(
            'Create\nnote',
            style: TextStyle(fontSize: 12),
          ),
          icon: const Icon(Icons.save),
        ),
      ),
    );
  }
}



  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       centerTitle: true,
  //       title: const Text('Creating a note'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           // Note's title
  //           Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: TextFormField(
  //                   controller: _noteTitleController,
  //                   decoration: const InputDecoration(
  //                     hintText: "Enter your note's title",
  //                     border: OutlineInputBorder(),
  //                   ),
  //                 ),
  //               ),
  //               // Note's body
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: TextFormField(
  //                   controller: _noteBodyController,
  //                   decoration: const InputDecoration(
  //                     hintText: "Enter your note's body",
  //                     border: OutlineInputBorder(),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 30),
  //           // Button to create a note
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
  //               minimumSize: const Size(200, 75),
  //               elevation: 30,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15),
  //               ),
  //             ),
  //             onPressed: () async {
  //               // Create note button
  //               try {
  //                 // Create a note on firebase
  //                 await NoteService.createNoteFirestore(
  //                   title: _noteTitleController.text,
  //                   body: _noteBodyController.text,
  //                   userId: currentUser.uid,
  //                   isFavorite: false,
  //                 ).then((_) {
  //                   Navigator.maybePop(context);
  //                 });
  //               } catch (errorMessage) {
  //                 ExceptionsAlertDialog.showErrorDialog(
  //                     context, errorMessage.toString());
  //               }
  //             },
  //             child: const Text(
  //               'Create a new note',
  //               style: TextStyle(
  //                 fontSize: 20,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

