import 'package:flutter/material.dart';
import 'package:mycustomnotes/utils/exceptions/exceptions_alert_dialog.dart';
import 'package:mycustomnotes/domain/services/auth_user_service.dart';
import 'package:mycustomnotes/domain/services/note_service.dart';

import '../../utils/dialogs/pick_note_color.dart';

class NoteCreatePage extends StatefulWidget {
  const NoteCreatePage({super.key});

  @override
  State<NoteCreatePage> createState() => _NoteCreatePageState();
}

class _NoteCreatePageState extends State<NoteCreatePage> {
  final currentUser = AuthUserService.getCurrentUserFirebase();
  final _noteTitleController = TextEditingController();
  final _noteBodyController = TextEditingController();
  bool isFavorite = false;
  bool _isCreateButtonVisible = false;
  Icon isFavoriteIcon = const Icon(
    Icons.star_outlined,
    color: Colors.grey,
    size: 28,
  );
  int intNoteColor = 0;
  Icon noteColorIcon = const Icon(
    Icons.palette,
    color: Colors.grey,
    size: 28,
  );
  Color noteColorPaletteIcon = Colors.grey;

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
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 2),
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    // Palette icon
                    // Zero is grey color
                    intNoteColor = await NotesColors.colorIntPickNoteDialog(
                        noteColor: 0, context: context);
                    setState(() {
                      noteColorPaletteIcon =
                          NotesColors.selectNoteColor(intNoteColor);
                    });
                  },
                  icon: Icon(
                    Icons.palette,
                    color: noteColorPaletteIcon,
                    size: 28,
                  ),
                ),
                IconButton(
                  icon: isFavoriteIcon,
                  onPressed: () {
                    setState(() {
                      // if it's not favorite, changes it to yellow and to true
                      // if it's favorite, then make it no favorite.
                      if (!isFavorite) {
                        isFavoriteIcon = const Icon(
                          Icons.star,
                          color: Colors.amberAccent,
                          size: 28,
                        );
                        isFavorite = true;
                        SnackBar snackBarIsFavoriteTrue =
                            favoriteNoteSnackBarMessage();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBarIsFavoriteTrue);
                      } else {
                        isFavoriteIcon = const Icon(
                          Icons.star_outlined,
                          color: Colors.grey,
                          size: 28,
                        );
                        isFavorite = false;
                      }
                    });
                  },
                ),
              ],
            ),
          )
        ],
        // Note title
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
            hintText: "Body",
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
              // Create note on firebase
              await NoteService.createNoteFirestore(
                title: _noteTitleController.text,
                body: _noteBodyController.text,
                userId: currentUser.uid,
                isFavorite: isFavorite,
                color: intNoteColor,
              ).then((_) => Navigator.maybePop(context));
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
