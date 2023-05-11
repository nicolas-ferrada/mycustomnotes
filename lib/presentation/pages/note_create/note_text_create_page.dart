import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/dialogs/insert_url_menu_options.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../../domain/services/auth_user_service.dart';
import '../../../domain/services/note_text_service.dart';
import 'package:provider/provider.dart';

import '../../../data/models/Note/note_notifier.dart';
import '../../../utils/icons/insert_url_icon_icons.dart';
import '../../../utils/internet/check_internet_connection.dart';
import '../../../utils/note_color/note_color.dart';
import '../../../utils/snackbars/snackbar_message.dart';

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

  // Url variables
  String? url;

  // When to show video
  bool isUrlVisible = false;

  // Did the url was modified? to show save button
  bool didUrlChanged = false;

  // Force the preview URL image to update
  late Key previewKey;

  @override
  void initState() {
    super.initState();
    previewKey = UniqueKey();
  }

  @override
  void dispose() {
    _noteTitleController.dispose();
    _noteBodyController.dispose();
    super.dispose();
  }

  Future<bool> isUrlValid({
    required String urlStr,
  }) async {
    try {
      final Uri url = Uri.parse(urlStr);
      // if it's valid, then apply it to the newNote object
      if (await canLaunchUrl(url)) {
        return true;
      } else {
        throw Exception('The url is not valid, try again.').removeExceptionWord;
      }
    } catch (errorMessage) {
      await ExceptionsAlertDialog.showErrorDialog(
          context: context, errorMessage: errorMessage.toString());
    }
    return false;
  }

  Future<void> launchingUrl({
    required String url,
  }) async {
    try {
      final Uri toLaunchUrl = Uri.parse(url);
      await launchUrl(toLaunchUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      await ExceptionsAlertDialog.showErrorDialog(
          context: context,
          errorMessage: 'Could not launch this URL, try adding other one');
    }
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
                final String? newUrl = await showDialog<String?>(
                  context: context,
                  builder: (context) {
                    return InsertUrlMenuOptions(
                      context: context,
                    );
                  },
                );
                if (newUrl != null) {
                  // if user tap on delete current url button, it will return that string
                  if (newUrl == 'deletecurrenturl') {
                    setState(() {
                      url = null;
                      didUrlChanged = true;
                      previewKey = UniqueKey();
                      isUrlVisible = false;
                    });
                  } else {
                    if (await isUrlValid(urlStr: newUrl)) {
                      setState(() {
                        didUrlChanged = true;
                        isUrlVisible = true;
                        url = newUrl;
                        previewKey = UniqueKey();
                      });
                    }
                  }
                }
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

  Widget noteCreatePageBody() {
    return Column(
      children: [
        // Url if exists
        Visibility(
          visible: isUrlVisible,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: AnyLinkPreview(
              onTap: () {
                String? finalUrl = url;
                if (finalUrl != null) {
                  launchingUrl(url: finalUrl);
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
              // urlLaunchMode: LaunchMode.externalApplication,
              link: url ?? '',
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
          ),
        ),
      ],
    );
  }
}
