import 'package:flutter/material.dart';
import 'package:mycustomnotes/enums/menu_item_note_detail.dart';
import 'package:mycustomnotes/exceptions/exceptions_alert_dialog.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/services/note_service.dart';
import '../../services/auth_user_service.dart';
import '../../utils/date_formatter.dart';

class NoteDetail extends StatefulWidget {
  final String noteId;
  const NoteDetail({super.key, required this.noteId});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final currentUser = AuthUserService.getCurrentUserFirebase();
  bool _isSaveButtonVisible = false;
  late String newTitle;
  late String newBody;
  late Note note;

  @override
  void initState() {
    super.initState();
    updateTitleBody();
  }

  // Show the title and the body on note detail
  updateTitleBody() async {
    try {
      await NoteService.readOneNoteFirestore(noteId: widget.noteId)
          .then((noteFromDB) {
        setState(() {
          note = noteFromDB;
          newTitle = note.title;
          newBody = note.body;
        });
      });
    } catch (errorMessage) {
      ExceptionsAlertDialog.showErrorDialog(context, errorMessage.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NoteService.readOneNoteFirestore(noteId: widget.noteId),
      builder: (context, snapshot) {
        // If one note was returned
        if (snapshot.hasData) {
          note = snapshot.data!;
          return Scaffold(
            // Note's title
            appBar: AppBar(
              actions: [
                // Note three dots detais (delete, date)
                menuButtonNote(),
              ],
              title: TextFormField(
                initialValue: note.title,
                onChanged: (value) {
                  setState(() {
                    // Used to edit the note
                    _isSaveButtonVisible = true;
                    newTitle = value;
                  });
                },
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
            // Note's body
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    // Used to edit the note
                    _isSaveButtonVisible = true;
                    newBody = value;
                  });
                },
                initialValue: note.body,
                textAlignVertical: TextAlignVertical.top,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Body',
                  border: InputBorder.none,
                ),
              ),
            ),
            // Save button, only visible if user changes the note
            floatingActionButton: Visibility(
              visible: _isSaveButtonVisible,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.amberAccent,
                label: const Text(
                  'Save\nchanges',
                  style: TextStyle(fontSize: 12),
                ),
                icon: const Icon(Icons.save),
                onPressed: () {
                  // Edit the selected note
                  try {
                    NoteService.editOneNoteFirestore(
                      title: newTitle,
                      body: newBody,
                      noteId: widget.noteId,
                      userId: currentUser.uid,
                      isFavorite: false,
                      // need to update ids?
                    ).then((_) => Navigator.maybePop(context));
                  } catch (errorMessage) {
                    ExceptionsAlertDialog.showErrorDialog(
                        context, errorMessage.toString());
                  }
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error has ocurred'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Menu note button (icon three dots)
  PopupMenuButton menuButtonNote() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == MenuItemNoteDetail.item1) {
          // Delete note
          deleteNoteDialog(context);
        } else if (value == MenuItemNoteDetail.item2) {
          // Mark as favorite
        } else if (value == MenuItemNoteDetail.item3) {
          // Share note
        } else if (value == MenuItemNoteDetail.item4) {
          // Note details
          noteDetailsDialog(context);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: MenuItemNoteDetail.item1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.delete, size: 30),
              Text('Delete'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.star, size: 30),
              Text('Favorite'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.share, size: 30),
              Text('Share'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.info, size: 30),
              Text('Details'),
            ],
          ),
        ),
      ],
    );
  }

  // Delete note dialog
  Future<void> deleteNoteDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: const Color.fromARGB(220, 250, 215, 90),
          title: const Center(
            child: Text('Confirmation'),
          ),
          content: const Text(
            'Do you really want to permanently delete this note?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  // Delete button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () async {
                      try {
                        // Delete a specified note
                        await NoteService.deleteOneNoteFirestore(
                                noteId: widget.noteId)
                            .then((_) => Navigator.pop(context)) // close dialog
                            .then((_) => Navigator.maybePop(
                                context)); // returns to the home page
                      } catch (errorMessage) {
                        ExceptionsAlertDialog.showErrorDialog(
                            context, errorMessage.toString());
                      }
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  // Cancel button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.maybePop(context);
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

  // Show note detail
  Future<void> noteDetailsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.grey,
          title: const Center(
            child: Text('Note details'),
          ),
          content: Column(
            children: [
              Text(
                'Creation date: ${DateFormatter.showDateFormatted(note.createdDate)}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              //Text('xd'),
            ],
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  // Close button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: const Text(
                      'Close',
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
}
