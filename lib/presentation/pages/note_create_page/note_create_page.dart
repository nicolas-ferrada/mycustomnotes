import 'package:flutter/material.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../../domain/services/auth_user_service.dart';
import '../../../domain/services/note_service.dart';
import 'package:provider/provider.dart';

import '../../../data/models/Note/note_notifier.dart';
import '../../../utils/note_color/note_color.dart';
import '../../../utils/snackbars/snackbar_message.dart';

class NoteCreatePage extends StatefulWidget {
  const NoteCreatePage({super.key});

  @override
  State<NoteCreatePage> createState() => _NoteCreatePageState();
}

class _NoteCreatePageState extends State<NoteCreatePage> {
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
      appBar: AppBar(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 2),
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    // Difine the palette color
                    Color newColor =
                        await NoteColorOperations.pickNoteColorDialog(
                            context: context);
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
                    size: 28,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.star,
                    color: noteColorFavoriteIcon,
                    size: 28,
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
          ),
        ],
      ),
      // Note's body
      body: noteCreatePageBody(),
      // Save button, only visible if user changes the note
      floatingActionButton: noteCreatePageFloatingActionButton(context),
    );
  }

  Visibility noteCreatePageFloatingActionButton(BuildContext context) {
    return Visibility(
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
              isFavorite: isNoteFavorite,
              color: intNoteColor,
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
        backgroundColor: Colors.amberAccent,
        label: const Text(
          'Create\nnote',
          style: TextStyle(fontSize: 12),
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
