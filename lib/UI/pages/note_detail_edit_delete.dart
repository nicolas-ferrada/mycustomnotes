import 'package:flutter/material.dart';
import 'package:mycustomnotes/enums/menu_item_note_detail.dart';
import 'package:mycustomnotes/exceptions/exceptions_alert_dialog.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/services/note_service.dart';
import 'package:mycustomnotes/utils/dialogs/confirmation_dialog.dart';
import 'package:mycustomnotes/utils/dialogs/note_details_info.dart';
import 'package:mycustomnotes/utils/dialogs/pick_note_color.dart';
import 'package:mycustomnotes/utils/snackbars/snackbar_message.dart';
import '../../services/auth_user_service.dart';

class NoteDetail extends StatefulWidget {
  final String noteId;
  const NoteDetail({super.key, required this.noteId});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final currentUser = AuthUserService.getCurrentUserFirebase();
  bool didUserMadeChanges = false;
  late Note note;
  late String newTitle;
  late String newBody;
  late bool isFavorite;
  late Icon isFavoriteIcon;
  late Color colorPalette;
  late int intNoteColor;
  bool wasTheSaveButtonPressed = false;

  @override
  void initState() {
    super.initState();
    updateNote();
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
          intNoteColor = note.color;
          isFavorite = note.isFavorite;
          colorPalette = NotesColors.selectNoteColor(intNoteColor);
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
          return WillPopScope(
            onWillPop: () async {
              FocusScope.of(context).unfocus(); // Avoids the bug of the keyboard showing for a sec
              // Triggers when user made changes and the save button is not pressed
              if (didUserMadeChanges == true &&
                  wasTheSaveButtonPressed == false) {
                final bool? shouldPop =
                    await ConfirmationDialog.discardChangesNoteDetails(context);
                return shouldPop ??
                    false; // If user tap outside dialog, then don't leave page
              } else {
                return true; // Come back to home page
              }
            },
            child: Scaffold(
              // Note's title
              appBar: AppBar(
                actions: [
                  // Note three dots detais (delete, date)
                  menuButtonNote(),
                ],
                title: TextFormField(
                  initialValue: note.title,
                  onChanged: (newTitleChanges) {
                    // Changes are being made
                    if (newTitleChanges != note.title) {
                      setState(() {
                        didUserMadeChanges = true;
                      });
                      newTitle = newTitleChanges;
                      // No changes
                    } else {
                      setState(() {
                        didUserMadeChanges = false;
                      });
                    }
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
                  initialValue: note.body,
                  onChanged: (newBodyChanges) {
                    // Changes are being made
                    if (newBodyChanges != note.body) {
                      setState(() {
                        didUserMadeChanges = true;
                      });
                      newBody = newBodyChanges;
                    } else {
                      setState(() {
                        didUserMadeChanges = false;
                      });
                    }
                  },
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
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Visibility saveButton(BuildContext context) {
    return Visibility(
      visible: didUserMadeChanges,
      child: FloatingActionButton.extended(
        backgroundColor: Colors.amberAccent,
        label: const Text(
          'Save\nchanges',
          style: TextStyle(fontSize: 12),
        ),
        icon: const Icon(Icons.save),
        onPressed: () async {
          // Edit the selected note
          try {
            wasTheSaveButtonPressed = true;

            await NoteService.editOneNoteFirestore(
              title: newTitle,
              body: newBody,
              isFavorite: isFavorite,
              color: intNoteColor,
              noteId: widget.noteId,
              userId: currentUser.uid,
            ).then((_) {
              Navigator.maybePop(context);
            });
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
          markAsFavoritePopupButton();
        } else if (value == MenuItemNoteDetail.item2) {
          // Pick color palette
          pickNoteColorPopupButton();
        } else if (value == MenuItemNoteDetail.item3) {
          // Share note
        } else if (value == MenuItemNoteDetail.item4) {
          // Note details
          NotesDetails.noteDetailsDialog(context, note);
        } else if (value == MenuItemNoteDetail.item5) {
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
            children: [
              Icon(
                Icons.palette,
                size: 28,
                color: colorPalette,
              ),
              const Text('Color'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.share, size: 28),
              Text('Share'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.info, size: 28),
              Text('Details'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item5,
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

  // PopupButton pick note color
  void pickNoteColorPopupButton() {
    // Gets the int note color and then applys to global var
    NotesColors.callColorIntPickNoteDialog(
      noteColor: note.color,
      context: context,
    )
        .then((int intColor) => setState(() {
              intNoteColor = intColor;
            }))
        .then((_) {
      // If the colors picked by user is not the same as the current notes color, send message
      if (intNoteColor != note.color) {
        // Shows a snackbar with the background color of the selected color by user
        Color noteColorPaletteIcon = NotesColors.selectNoteColor(intNoteColor);
        SnackBar snackBarNoteColor = SnackBarMessage.snackBarMessage(
            message: "Your note's color has changed",
            backgroundColor: noteColorPaletteIcon);
        ScaffoldMessenger.of(context).showSnackBar(snackBarNoteColor);
        setState(() {
          colorPalette =
              noteColorPaletteIcon; // Changes the color of the icon to the new one
          didUserMadeChanges = true; // Show the save button
        });
      } else {
        setState(() {
          didUserMadeChanges = false; // Hide the save button
        });
      }
    });
  }

  // PopupButton favorite
  void markAsFavoritePopupButton() {
    // It's not favorite, so change it to favorite
    if (!isFavorite) {
      setState(() {
        isFavoriteIcon = const Icon(
          Icons.star,
          color: Colors.amberAccent,
          size: 28,
        );
        isFavorite = true;
      });
      SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
        message: 'Note marked as favorite',
        backgroundColor: Colors.amber.shade300,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
      // Note now it's favorite, if it was favorite from the start, then user did not make any changes
      if (note.isFavorite) {
        setState(() {
          didUserMadeChanges = false;
        });
        // Note now it's favorite, but it wasn't from the start, so user make a change
      } else {
        setState(() {
          didUserMadeChanges = true;
        });
      }
    } else {
      setState(() {
        isFavoriteIcon = const Icon(
          Icons.star_outlined,
          color: Colors.white,
          size: 28,
        );
        isFavorite = false;
      });
      SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
        message: 'Note removed from favorites',
        backgroundColor: Colors.grey,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
      // Note now it's not favorite, if it was favorite from the start, then user did make a change
      if (note.isFavorite) {
        setState(() {
          didUserMadeChanges = true;
        });
        // Note now it's favorite, but it wasn't from the start, so user make a change
      } else {
        setState(() {
          didUserMadeChanges = false;
        });
      }
    }
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
}
