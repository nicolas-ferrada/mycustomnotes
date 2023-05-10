import 'package:flutter/material.dart';
import '../../../../utils/dialogs/insert_menu_options.dart';
import '../../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../../../domain/services/auth_user_service.dart';
import '../../../../domain/services/note_text_service.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/Note/note_notifier.dart';
import '../../../../utils/icons/insert_url_icon_icons.dart';
import '../../../../utils/internet/check_internet_connection.dart';
import '../../../../utils/note_color/note_color.dart';
import '../../../../utils/snackbars/snackbar_message.dart';

class NoteTextCreatePage extends StatefulWidget {
  const NoteTextCreatePage({super.key});

  @override
  State<NoteTextCreatePage> createState() => _NoteTextCreatePageState();
}

class _NoteTextCreatePageState extends State<NoteTextCreatePage> {
  final currentUser = AuthUserService.getCurrentUserFirebase();

  final _noteTitleController = TextEditingController();
  final _noteBodyController = TextEditingController();

  bool isNoteFavorite = false;

  bool _isCreateButtonVisible = false;

  int intNoteColor = 0;

  Color noteColorPaletteIcon = Colors.grey;
  Color noteColorFavoriteIcon = Colors.grey;

  @override
  void dispose() {
    _noteTitleController.dispose();
    _noteBodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Note's title, favorite and pick color icons
      appBar: noteCreatePageTitle(context),
      // Note's body
      body: noteCreatePageBody(),
      // Save button, only visible if user changes the note
      floatingActionButton: noteCreatePageFloatingActionButton(context),
    );
  }

  AppBar noteCreatePageTitle(BuildContext context) {
    return AppBar(
      title: TextFormField(
        controller: _noteTitleController,
        onChanged: (value) {
          setState(() {
            _isCreateButtonVisible = true;
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Title",
          hintStyle: TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      actions: [
        Row(
          children: [
            // Insert
            IconButton(
              icon: Icon(
                InsertUrlIcon.link,
                color: noteColorFavoriteIcon,
                size: 20,
              ),
              onPressed: () async {
                // Load an url
                // final String? url = await showDialog<String?>(
                //   context: context,
                //   builder: (context) {
                //     return InsertMenuOptions(
                //       context: context,
                //     );
                //   },
                // );
                // if (url != null) {
                //   // if user tap on delete current url button, it will return that string
                //   if (url == 'deletecurrenturl') {
                //     setState(() {
                //       newNote.url = null;
                //       didUrlChanged = true;
                //       previewKey = UniqueKey();
                //       isUrlVisible = false;
                //     });
                //   } else {
                //     validateUrl(urlStr: url).then((finalUrl) {
                //       setState(() {
                //         isUrlVisible = true;
                //         newNote.url = finalUrl;
                //         previewKey = UniqueKey();
                //       });
                //     });
                //   }
                // }
              },
            ),
            // Color
            IconButton(
              onPressed: () async {
                late Color newColor;
                Color? getColorFromDialog =
                    await NoteColorOperations.pickNoteColorDialog(
                        context: context);
                if (getColorFromDialog != null) {
                  newColor = getColorFromDialog;
                } else {
                  newColor = NoteColorOperations.getColorFromNumber(
                      colorNumber: intNoteColor);
                }
                // Difine the note color
                intNoteColor =
                    NoteColorOperations.getNumberFromColor(color: newColor);
                setState(() {
                  noteColorPaletteIcon = newColor;
                });
              },
              icon: Icon(
                Icons.palette,
                color: noteColorPaletteIcon,
                size: 24,
              ),
            ),
            // Favorite
            IconButton(
              icon: Icon(
                Icons.star,
                color: noteColorFavoriteIcon,
                size: 24,
              ),
              onPressed: () {
                if (!isNoteFavorite) {
                  // It was not favorite, now it is
                  setState(() {
                    noteColorFavoriteIcon = Colors.amberAccent;
                  });
                  isNoteFavorite = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBarMessage.snackBarMessage(
                          message: 'Note marked as favorite',
                          backgroundColor: Colors.amberAccent));
                } else {
                  // It was favorite, now it is not
                  setState(() {
                    noteColorFavoriteIcon = Colors.grey;
                  });
                  isNoteFavorite = false;
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Visibility noteCreatePageFloatingActionButton(BuildContext context) {
    return Visibility(
      visible: _isCreateButtonVisible,
      child: FloatingActionButton.extended(
        onPressed: () async {
          // Create note button
          try {
            // Check if device it's connected to any network
            bool isDeviceConnected =
                await CheckInternetConnection.checkInternetConnection();
            int waitingConnection = 5;

            // If device is connected, wait 5 seconds, if is not connected, dont wait.
            if (isDeviceConnected) {
              waitingConnection = 5;
            } else {
              waitingConnection = 0;
            }

            // Create note on firebase, it will wait depending if the device it's connected to a network
            await NoteTextService.createNoteText(
              title: _noteTitleController.text,
              body: _noteBodyController.text,
              userId: currentUser.uid,
              isFavorite: isNoteFavorite,
              color: intNoteColor,
            ).timeout(
              Duration(seconds: waitingConnection),
              onTimeout: () {
                Provider.of<NoteNotifier>(context, listen: false)
                    .refreshNotes();

                Navigator.of(context).maybePop();
              },
            );
            if (context.mounted) {
              Provider.of<NoteNotifier>(context, listen: false).refreshNotes();

              Navigator.of(context).maybePop();
            }
          } catch (errorMessage) {
            ExceptionsAlertDialog.showErrorDialog(
                context: context, errorMessage: errorMessage.toString());
          }
        },
        backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
        label: const Text(
          'Save',
        ),
        icon: const Icon(Icons.save),
      ),
    );
  }

  Padding noteCreatePageBody() {
    return Padding(
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
          hintText: "Body",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
