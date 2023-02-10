import 'package:flutter/material.dart';
import 'package:mycustomnotes/enums/menu_item_note_detail.dart';
import 'package:mycustomnotes/exceptions/exceptions_alert_dialog.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/services/note_service.dart';
import '../../services/auth_user_service.dart';
import '../../utils/formatters/date_formatter.dart';

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
  late bool isFavorite;
  late Icon isFavoriteIcon;
  late bool isFavoriteFirst;

  @override
  void initState() {
    super.initState();
    updateNote();
  }

  @override
  void dispose() {
    //
    try {
      // Updates note isFavorite field if it changed
      if (isFavoriteFirst != isFavorite) {
        NoteService.updateNoteFavoriteDispose(
          noteId: widget.noteId,
          isFavorite: isFavorite,
        );
      }
    } catch (errorMessage) {
      ExceptionsAlertDialog.showErrorDialog(context, errorMessage.toString());
    }
    super.dispose();
  }

  // Update some attributes of the note beforehand
  updateNote() async {
    try {
      await NoteService.readOneNoteFirestore(noteId: widget.noteId)
          .then((noteFromDB) {
        setState(() {
          note = noteFromDB;
          newTitle = note.title;
          newBody = note.body;
          isFavorite = note.isFavorite;
          isFavoriteFirst =
              note.isFavorite; // only modify the note favorite if changes

          // If it's note favorite, var will be yellow start, if not, white star
          note.isFavorite
              ? isFavoriteIcon = const Icon(
                  Icons.star,
                  color: Colors.amberAccent,
                  size: 28,
                )
              : isFavoriteIcon = const Icon(
                  Icons.star_outlined,
                  color: Colors.white,
                  size: 28,
                );
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
        if (snapshot.hasError) {
          return Center(
            child: Text('An error has ocurred: ${snapshot.error.toString()}'),
          );
        }
        // If one note was returned
        else if (snapshot.hasData) {
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
            floatingActionButton: saveButton(context),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Visibility saveButton(BuildContext context) {
    return Visibility(
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
              isFavorite: isFavorite,
              color: note.color,
              // need to update ids?
            ).then((_) => Navigator.maybePop(context));
          } catch (errorMessage) {
            ExceptionsAlertDialog.showErrorDialog(
                context, errorMessage.toString());
          }
        },
      ),
    );
  }

  // Menu note button (icon three dots)
  PopupMenuButton menuButtonNote() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == MenuItemNoteDetail.item1) {
          // Mark as favorite
          if (!isFavorite) {
            setState(() {
              isFavoriteIcon = const Icon(
                Icons.star,
                color: Colors.amberAccent,
                size: 28,
              );
              isFavorite = true;
            });
            SnackBar snackBarIsFavoriteTrue = favoriteNoteSnackBarMessage();
            ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavoriteTrue);
          } else {
            setState(() {
              isFavoriteIcon = const Icon(
                Icons.star_outlined,
                color: Colors.white,
                size: 28,
              );
              isFavorite = false;
            });
          }
        } else if (value == MenuItemNoteDetail.item2) {
          // Share note
        } else if (value == MenuItemNoteDetail.item3) {
          // Note details
          noteDetailsDialog(context);
        } else if (value == MenuItemNoteDetail.item4) {
          // Delete note
          deleteNoteDialog(context);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: MenuItemNoteDetail.item1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // If it's favorite, show yellow icon, if not, white
              isFavoriteIcon,
              const Text('Favorite'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.share, size: 28),
              Text('Share'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.info, size: 28),
              Text('Details'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.delete, size: 28),
              Text('Delete'),
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

  SnackBar favoriteNoteSnackBarMessage() {
    const snackBarIsFavoriteTrue = SnackBar(
      duration: Duration(seconds: 1),
      content: Center(
        child: Text(
          'Note marked as favorite',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.amberAccent,
    );
    return snackBarIsFavoriteTrue;
  }
}