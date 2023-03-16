import 'package:flutter/material.dart';
import '../../../utils/enums/menu_item_note_detail.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../../data/models/Note/note_model.dart';
import '../../../domain/services/note_service.dart';
import '../../../utils/dialogs/confirmation_dialog.dart';
import '../../../utils/dialogs/note_details_info.dart';
import '../../../utils/note_color/note_color.dart';
import '../../../utils/snackbars/snackbar_message.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/Note/note_notifier.dart';
import '../../../domain/services/auth_user_service.dart';
import 'dart:developer' as log;

class NoteDetailsPage extends StatefulWidget {
  final Note note;
  const NoteDetailsPage({super.key, required this.note});

  @override
  State<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  // Access firebase user
  final currentUser = AuthUserService.getCurrentUserFirebase();

  // Makes the save button to show up
  bool didUserMadeChanges = false;

  // Avoids dialog of leaving page confirmation to triggers if the save button was pressed
  bool wasTheSaveButtonPressed = false;

  // Handles the color of the favorite star icon and color palette icon
  late Color isFavoriteIconColor;
  late Color colorIconPalette;

  // New note object which is going to be modified so it can be stored later with the new data
  late Note newNote;

  @override
  void initState() {
    super.initState();
    updateNote();
  }

  void updateNote() {
    newNote = widget.note.copyWith();
    if (widget.note.isFavorite) {
      isFavoriteIconColor = Colors.amber;
    } else {
      isFavoriteIconColor = Colors.white;
    }
    colorIconPalette =
        NoteColorOperations.getColorFromNumber(colorNumber: widget.note.color);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context)
            .unfocus(); // Avoids the bug of the keyboard showing for a sec
        // Triggers when user made changes and the save button is not pressed
        if (didUserMadeChanges == true && wasTheSaveButtonPressed == false) {
          final bool? shouldPop =
              await ConfirmationDialog.discardChangesNoteDetails(context);
          return shouldPop ??
              false; // If user tap outside dialog, then don't leave page
        } else {
          return true; // Come back to home page
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // Note actions (three dots detais)
            menuButtonNote(),
          ],
          // Note's title
          title: TextFormField(
            initialValue: widget.note.title,
            onChanged: (newTitleChanged) {
              // Changes are being made
              if (newTitleChanged != widget.note.title) {
                setState(() {
                  didUserMadeChanges = true;
                });
                newNote.title = newTitleChanged;
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

        body: Column(
          children: [
            // Note's body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  initialValue: widget.note.body,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Body',
                    border: InputBorder.none,
                  ),
                  onChanged: (newBodyChanged) {
                    // Changes are being made
                    if (newBodyChanged != widget.note.body) {
                      newNote.body = newBodyChanged;
                      setState(() {
                        didUserMadeChanges = true;
                      });
                    } else {
                      setState(() {
                        didUserMadeChanges = false;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        // Save button, only visible if user changes the note
        floatingActionButton: saveButton(context),
      ),
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
            await NoteService.editNote(note: newNote);

            if (context.mounted) {
              Provider.of<NoteNotifier>(context, listen: false).refreshNotes();
            }

            if (context.mounted) Navigator.maybePop(context);
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
      onSelected: (value) async {
        if (value == MenuItemNoteDetail.item1) {
          // Mark as favorite
          markAsFavoritePopupButton();
        } else if (value == MenuItemNoteDetail.item2) {
          // Pick color palette
          pickNoteColorPopupButton();
        } else if (value == MenuItemNoteDetail.item3) {
          // Load an url
        } else if (value == MenuItemNoteDetail.item4) {
          // Share note
          Share.share('${widget.note.title}\n\n${widget.note.body}');
        } else if (value == MenuItemNoteDetail.item5) {
          // Note details
          NotesDetails.noteDetailsDialog(context, widget.note);
        } else if (value == MenuItemNoteDetail.item6) {
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
              Icon(
                Icons.star,
                color: isFavoriteIconColor,
                size: 28,
              ),
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
                color: colorIconPalette,
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
              Icon(Icons.insert_drive_file, size: 28),
              Text('Insert'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.share, size: 28),
              Text('Share'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.info, size: 28),
              Text('Details'),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item6,
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

  // POPUPMENU BUTTONS

  // PopupButton favorite
  void markAsFavoritePopupButton() {
    // The new note it's not favorite, so change it to favorite
    if (!newNote.isFavorite) {
      newNote.isFavorite = true;
      setState(() {
        isFavoriteIconColor = Colors.amber;
      });
      // Note now it's favorite, if it was favorite from the start, then user did not make any changes
      if (widget.note.isFavorite) {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message: 'Note marked as favorite again, no changes were made.',
          backgroundColor: Colors.amber.shade300,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didUserMadeChanges = false;
        });
        // Note now it's favorite, but it wasn't from the start, so user make a change
      } else {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message: 'Note selected as favorite.',
          backgroundColor: Colors.amber.shade300,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didUserMadeChanges = true;
        });
      }
    } else {
      // It's favorite, so change it to not favorite
      newNote.isFavorite = false;
      setState(() {
        isFavoriteIconColor = Colors.white;
      });
      // Note now it's not favorite, if it was favorite from the start, then user did make a change
      if (widget.note.isFavorite) {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message: 'Note removed from favorite.',
          backgroundColor: Colors.white,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didUserMadeChanges = true;
        });
        // Note now it's favorite, but it wasn't from the start, so user make a change
      } else {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message: 'Note removed again from favorite, no changes were made.',
          backgroundColor: Colors.grey,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didUserMadeChanges = false;
        });
      }
    }
  }

  // PopupButton pick note color
  void pickNoteColorPopupButton() async {
    // Get the note color picked by the user, if no color is picked, keeps the original color
    late Color colorPickedByUser;
    Color? getColorFromDialog =
        await NoteColorOperations.pickNoteColorDialog(context: context);
    if (getColorFromDialog != null) {
      colorPickedByUser = getColorFromDialog;
    } else {
      colorPickedByUser = NoteColorOperations.getColorFromNumber(
          colorNumber: widget.note.color);
    }

    newNote.color =
        NoteColorOperations.getNumberFromColor(color: colorPickedByUser);
    // If the colors picked by user is not the same as the current notes color, send message
    if (newNote.color != widget.note.color) {
      // Shows a snackbar with the background color selected by user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarMessage.snackBarMessage(
              message: "New color selected to be applied",
              backgroundColor: colorPickedByUser),
        );
      }
      setState(() {
        // Changes the color of the icon to the new one
        colorIconPalette = colorPickedByUser;
        // Show the save button
        didUserMadeChanges = true;
      });
    } else {
      // User picked the same color
      setState(() {
        // Changes the color of the icon to the current note color
        didUserMadeChanges = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarMessage.snackBarMessage(
              message: "Your note already have this color",
              backgroundColor: colorPickedByUser),
        );
      });
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
                        await NoteService.deleteNote(noteId: widget.note.id);
                        if (context.mounted) {
                          Provider.of<NoteNotifier>(context, listen: false)
                              .refreshNotes();
                        }

                        if (context.mounted) Navigator.pop(context);
                        if (context.mounted) Navigator.maybePop(context);
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
