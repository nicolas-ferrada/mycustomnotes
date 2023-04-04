import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/Note/note_notifier.dart';
import '../../../../data/models/Note/note_text_model.dart';
import '../../../../domain/services/auth_user_service.dart';
import '../../../../domain/services/note_text_service.dart';
import '../../../../utils/dialogs/confirmation_dialog.dart';
import '../../../../utils/dialogs/delete_note_confirmation.dart';
import '../../../../utils/dialogs/insert_menu_options.dart';
import '../../../../utils/dialogs/note_details_info.dart';
import '../../../../utils/enums/menu_item_note_detail.dart';
import '../../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../../../utils/internet/check_internet_connection.dart';
import '../../../../utils/note_color/note_color.dart';
import '../../../../utils/snackbars/snackbar_message.dart';

class NoteTextDetailsPage extends StatefulWidget {
  final NoteText noteText;
  const NoteTextDetailsPage({super.key, required this.noteText});

  @override
  State<NoteTextDetailsPage> createState() => _NoteTextDetailsPageState();
}

class _NoteTextDetailsPageState extends State<NoteTextDetailsPage> {
  // Access firebase user
  final currentUser = AuthUserService.getCurrentUserFirebase();

  // Makes the save button to show up
  bool didTitleChanged = false;
  bool didBodyChanged = false;
  bool didColorChanged = false;
  bool didFavoriteChanged = false;
  bool didUrlChanged = false;

  // Avoids dialog of leaving page confirmation to triggers if the save button was pressed
  bool wasTheSaveButtonPressed = false;

  // Handles the color of the favorite star icon and color palette icon
  late Color isFavoriteIconColor;
  late Color colorIconPalette;

  // New note object which is going to be modified so it can be stored later with the new data
  late NoteText newNote;

  bool isUrlVisible = false;

  // Force the preview URL image to update
  late Key previewKey;

  @override
  void initState() {
    super.initState();
    previewKey = UniqueKey();
    updateNote();
  }

  void updateNote() {
    // Copy the original object to create the a new note, which attributes will be modified by user
    newNote = widget.noteText.copyWith();
    if (widget.noteText.isFavorite) {
      isFavoriteIconColor = Colors.amber;
    } else {
      isFavoriteIconColor = Colors.white;
    }
    colorIconPalette = NoteColorOperations.getColorFromNumber(
        colorNumber: widget.noteText.color);
    if (widget.noteText.url != null) {
      isUrlVisible = true;
    }
  }

  Future<String> validateUrl({
    required String urlStr,
  }) async {
    try {
      final Uri url = Uri.parse(urlStr);
      // if it's valid, then apply it to the newNote object
      if (await canLaunchUrl(url)) {
        setState(() {
          didUrlChanged = true;
        });
        return urlStr;
      } else {
        throw Exception();
      }
    } catch (_) {
      await ExceptionsAlertDialog.showErrorDialog(
          context, 'Invalid URL, try again');
    }
    return urlStr;
  }

  Future<void> launchingUrl({
    required String url,
  }) async {
    try {
      final Uri toLaunchUrl = Uri.parse(url);
      await launchUrl(toLaunchUrl);
    } catch (e) {
      await ExceptionsAlertDialog.showErrorDialog(
          context, 'Could not launch this URL, try adding other one');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Avoids the bug of the keyboard showing for a sec
        FocusScope.of(context).unfocus();
        // Triggers when user made changes and the save button was not pressed
        bool didUserMadeChanges = (didTitleChanged ||
            didBodyChanged ||
            didFavoriteChanged ||
            didColorChanged ||
            didUrlChanged);
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
            initialValue: widget.noteText.title,
            onChanged: (newTitleChanged) {
              // Changes are being made
              if (newTitleChanged != widget.noteText.title) {
                setState(() {
                  didTitleChanged = true;
                });
                newNote.title = newTitleChanged.trim();
                // No changes
              } else {
                setState(() {
                  didTitleChanged = false;
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
            // Url if exists
            Visibility(
              visible: isUrlVisible,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: AnyLinkPreview(
                  onTap: () {
                    String? url = newNote.url;
                    if (url != null) {
                      launchingUrl(url: url);
                    }
                  },
                  key: previewKey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  urlLaunchMode: LaunchMode.externalApplication,
                  link: newNote.url ?? '',
                  borderRadius: 0,
                  displayDirection: UIDirection.uiDirectionVertical,
                  backgroundColor: Colors.white70,
                  errorTitle: "Error: can't load the title..",
                  errorBody: "Error: can't load the content..",
                  errorWidget: Container(
                    color: Colors.red.shade900,
                    child: const Center(
                      child: Text("Error: can't load any image.."),
                    ),
                  ),
                ),
              ),
            ),
            // Note's body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  initialValue: widget.noteText.body,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Body',
                    border: InputBorder.none,
                  ),
                  onChanged: (newBodyChanged) {
                    // Changes are being made
                    if (newBodyChanged != widget.noteText.body) {
                      newNote.body = newBodyChanged.trim();
                      setState(() {
                        didBodyChanged = true;
                      });
                    } else {
                      setState(() {
                        didBodyChanged = false;
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
    bool didUserMadeChanges = (didTitleChanged ||
        didBodyChanged ||
        didFavoriteChanged ||
        didColorChanged ||
        didUrlChanged);
    return Visibility(
      // Button will be visible if any field changed
      visible: didUserMadeChanges,
      child: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
        label: const Text(
          'Save',
        ),
        icon: const Icon(Icons.save),
        onPressed: () async {
          // Edit the selected note
          try {
            wasTheSaveButtonPressed = true;

            // Check if device it's connected to any network
            bool isDeviceConnected =
                await CheckInternetConnection.checkInternetConnection();
            int waitingToConnectiong = 5;

            // If device is connected, wait 5 seconds, if is not connected, dont wait.
            if (isDeviceConnected) {
              waitingToConnectiong = 5;
            } else {
              waitingToConnectiong = 0;
            }
            await NoteTextService.editNoteText(note: newNote).timeout(
              Duration(seconds: waitingToConnectiong),
              onTimeout: () {
                Provider.of<NoteNotifier>(context, listen: false)
                    .refreshNotes();

                Navigator.maybePop(context);
              },
            );

            if (context.mounted) {
              Provider.of<NoteNotifier>(context, listen: false).refreshNotes();
              Navigator.maybePop(context);
            }
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
    // Required
    // IMPORTANT: Current note, didUserMadeChanges so to know when ask the user to save
    // Less important: Icons colors
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
          final String? url = await showDialog<String?>(
            context: context,
            builder: (context) {
              return InsertMenuOptions(
                context: context,
              );
            },
          );

          if (url != null) {
            // if user tap on delete current url button, it will return that string
            if (url == 'deletecurrenturl') {
              newNote.url = null;
              didUrlChanged = true;
            } else {
              validateUrl(urlStr: url).then((finalUrl) {
                setState(() {
                  newNote.url = finalUrl;
                  previewKey = UniqueKey();
                });
              });
            }
          }

          // load url to firestore
        } else if (value == MenuItemNoteDetail.item4) {
          // Share note
          Share.share('${widget.noteText.title}\n\n${widget.noteText.body}');
        } else if (value == MenuItemNoteDetail.item5) {
          // Note details
          NotesDetails.noteDetailsDialog(context, widget.noteText);
        } else if (value == MenuItemNoteDetail.item6) {
          // Delete note
          DeleteNoteConfirmation.deleteNoteDialog(
              context: context, note: widget.noteText);
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
      if (widget.noteText.isFavorite) {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message: 'Note marked as favorite again, no changes were made.',
          backgroundColor: Colors.amber.shade300,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didFavoriteChanged = false;
        });
        // Note now it's favorite, but it wasn't from the start, so user made a change
      } else {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message: 'Note selected as favorite.',
          backgroundColor: Colors.amber.shade300,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didFavoriteChanged = true;
        });
      }
    } else {
      // It's favorite, so change it to not favorite
      newNote.isFavorite = false;
      setState(() {
        isFavoriteIconColor = Colors.white;
      });
      // Note now it's not favorite, if it was favorite from the start, then user did make a change
      if (widget.noteText.isFavorite) {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message: 'Note removed from favorite.',
          backgroundColor: Colors.grey,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didFavoriteChanged = true;
        });
        // Note now it's favorite, but it wasn't from the start, so user make a change
      } else {
        SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
          message: 'Note removed again from favorite, no changes were made.',
          backgroundColor: Colors.grey,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        setState(() {
          didFavoriteChanged = false;
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
          colorNumber: widget.noteText.color);
    }

    newNote.color =
        NoteColorOperations.getNumberFromColor(color: colorPickedByUser);
    // If the colors picked by user is not the same as the current notes color, send message
    if (newNote.color != widget.noteText.color) {
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
        didColorChanged = true;
      });
    } else {
      // User picked the same color
      setState(() {
        // Changes the color of the icon to the current note color
        didColorChanged = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarMessage.snackBarMessage(
              message: "Your note already have this color",
              backgroundColor: colorPickedByUser),
        );
      });
    }
  }

  Future<String?> showUrlDialogAndGetResult() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return InsertMenuOptions(
          context: context,
        );
      },
    );
  }
}
