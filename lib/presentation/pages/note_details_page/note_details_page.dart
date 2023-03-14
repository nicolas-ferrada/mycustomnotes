import 'package:flutter/material.dart';
import '../../../utils/enums/menu_item_note_detail.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../../data/models/Note/note_model.dart';
import '../../../domain/services/note_service.dart';
import '../../../utils/dialogs/confirmation_dialog.dart';
import '../../../utils/dialogs/insert_menu_options.dart';
import '../../../utils/dialogs/note_details_info.dart';
import '../../../utils/note_color/note_color.dart';
import '../../../utils/snackbars/snackbar_message.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../data/models/Note/note_notifier.dart';
import '../../../domain/services/auth_user_service.dart';
import 'dart:developer' as log;

class NoteDetailsPage extends StatefulWidget {
  final String noteId;
  const NoteDetailsPage({super.key, required this.noteId});

  @override
  State<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
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
  late YoutubePlayerController _youtubeController;
  late String? youtubeUrl;
  bool isYoutubeplayerInitializated = false;
  bool isVideoFullScreen = false;

  @override
  void initState() {
    super.initState();
    updateNote();
  }

  @override
  void dispose() {
    if (isYoutubeplayerInitializated) {
      _youtubeController.dispose();
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
          intNoteColor = note.color;
          isFavorite = note.isFavorite;
          colorPalette =
              NoteColorOperations.getColorFromNumber(colorNumber: intNoteColor);
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
          youtubeUrl = note.youtubeUrl;
          if (note.youtubeUrl != null) {
            setState(() {
              _youtubeController = YoutubePlayerController(
                initialVideoId: YoutubePlayer.convertUrlToId(youtubeUrl!)!,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  loop: false,
                  mute: false,
                ),
              );
              isYoutubeplayerInitializated = true;
            });
          }

          // If the note has a youtube url
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
              FocusScope.of(context)
                  .unfocus(); // Avoids the bug of the keyboard showing for a sec
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
              appBar: isVideoFullScreen
                  ? null
                  : AppBar(
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
              body: Column(
                children: [
                  // If the note has a url, then show it
                  youtubeUrl != null
                      ? YoutubePlayerBuilder(
                          onEnterFullScreen: () {
                            setState(() {
                              setState(() {
                                log.log(
                                    '${isVideoFullScreen.toString()} full scren');
                                isVideoFullScreen = true;
                              });
                            });
                          },
                          onExitFullScreen: () {
                            setState(() {
                              isVideoFullScreen = false;
                              log.log(
                                  '${isVideoFullScreen.toString()} exit scren');
                            });
                          },
                          player: YoutubePlayer(
                            controller: _youtubeController,
                            showVideoProgressIndicator: true,
                          ),
                          builder: (context, player) {
                            return Container(
                              height: isVideoFullScreen
                                  ? MediaQuery.of(context).size.height
                                  : MediaQuery.of(context).size.width * 9 / 16,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.zero,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(1),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: player,
                            );
                          })
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        initialValue: note.body,
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: 'Body',
                          border: InputBorder.none,
                        ),
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
                      ),
                    ),
                  ),
                ],
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
              youtubeUrl: youtubeUrl,
            );
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
          // Insert video or image
          try {
            youtubeUrl = await showDialog(
                context: context,
                builder: (_) {
                  return InsertMenuOptions(
                    context: context,
                    noteCurrentUrl: note.youtubeUrl,
                  );
                });
            if (youtubeUrl != null) {
              // Database did not have any video url
              if (isYoutubeplayerInitializated == false) {
                setState(() {
                  _youtubeController = YoutubePlayerController(
                    initialVideoId: YoutubePlayer.convertUrlToId(youtubeUrl!)!,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      loop: false,
                      mute: false,
                    ),
                  );
                  isYoutubeplayerInitializated = true;
                  // Only show save button if the url is different
                  didUserMadeChanges = true;
                });
              } else {
                // After controller it's initializated, then just load videos
                setState(() {
                  _youtubeController
                      .load(YoutubePlayer.convertUrlToId(youtubeUrl!)!);
                  // Only show save button if the url is different
                  if (youtubeUrl != note.youtubeUrl) {
                    didUserMadeChanges = true;
                  } else {
                    didUserMadeChanges = false;
                  }
                });
              }
            }
          } catch (errorMessage) {
            ExceptionsAlertDialog.showErrorDialog(
                context, errorMessage.toString());
          }
          // flags and load the url to database
        } else if (value == MenuItemNoteDetail.item4) {
          // Share note
          Share.share('${note.title}\n\n${note.body}');
        } else if (value == MenuItemNoteDetail.item5) {
          // Note details
          NotesDetails.noteDetailsDialog(context, note);
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

  // PopupButton pick note color
  void pickNoteColorPopupButton() async {
    // Gets the int note color and then applys to global var
    Color colorPickedByUser =
        await NoteColorOperations.pickNoteColorDialog(context: context);

    intNoteColor =
        NoteColorOperations.getNumberFromColor(color: colorPickedByUser);

    // If the colors picked by user is not the same as the current notes color, send message
    if (intNoteColor != note.color) {
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
        colorPalette = colorPickedByUser;
        // Show the save button
        didUserMadeChanges = true;
      });
    } else {
      // User picked the same color
      setState(() {
        // Changes the color of the icon to the current note color
        colorPalette =
            NoteColorOperations.getColorFromNumber(colorNumber: note.color);
        // Hide the save button
        didUserMadeChanges = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarMessage.snackBarMessage(
              message: "Your note already have this color",
              backgroundColor: colorPalette),
        );
      });
    }
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
      // Note now it's favorite, if it was favorite from the start, then user did not make any changes
      if (note.isFavorite) {
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
      setState(() {
        isFavoriteIcon = const Icon(
          Icons.star_outlined,
          color: Colors.white,
          size: 28,
        );
        isFavorite = false;
      });
      // Note now it's not favorite, if it was favorite from the start, then user did make a change
      if (note.isFavorite) {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message: 'Note removed from favorite.',
          backgroundColor: Colors.grey,
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
                            noteId: widget.noteId);
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
