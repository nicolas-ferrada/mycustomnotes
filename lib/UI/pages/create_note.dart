import 'package:flutter/material.dart';
import 'package:mycustomnotes/exceptions/exceptions_alert_dialog.dart';
import 'package:mycustomnotes/services/auth_user_service.dart';
import 'package:mycustomnotes/services/note_service.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
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
  int noteColor = 0;
  Icon noteColorIcon = const Icon(
    Icons.palette,
    color: Colors.grey,
    size: 28,
  );

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
            // Favorite star icon
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    colorPickNoteDialog(context);
                  },
                  icon: noteColorIcon,
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
                color: noteColor,
              ).then((_) {
                Navigator.maybePop(context);
              });
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

  Future colorPickNoteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.grey,
          title: const Center(
            child: Text("Pick the note's color"),
          ),
          content: Row(
            children: [
              // Yellow
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      noteColor = 1;
                      noteColorIcon = Icon(
                        Icons.palette,
                        color: Colors.amber.shade300,
                        size: 28,
                      );
                    });
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: Colors.amber.shade300,
                  ),
                ),
              ),
              // Green
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      noteColor = 2;
                      noteColorIcon = Icon(
                        Icons.palette,
                        color: Colors.green.shade300,
                        size: 28,
                      );
                    });
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: Colors.green.shade300,
                  ),
                ),
              ),
              // Blue
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      noteColor = 3;
                      noteColorIcon = Icon(
                        Icons.palette,
                        color: Colors.lightBlue.shade300,
                        size: 28,
                      );
                    });
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: Colors.lightBlue.shade300,
                  ),
                ),
              ),
              // Orange
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      noteColor = 4;
                      noteColorIcon = Icon(
                        Icons.palette,
                        color: Colors.orange.shade300,
                        size: 28,
                      );
                    });
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: Colors.orange.shade300,
                  ),
                ),
              ),
              // Pink
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      noteColor = 5;
                      noteColorIcon = Icon(
                        Icons.palette,
                        color: Colors.pinkAccent.shade100,
                        size: 28,
                      );
                    });
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: Colors.pinkAccent.shade100,
                  ),
                ),
              ),
              // Sky-blue
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      noteColor = 6;
                      noteColorIcon = Icon(
                        Icons.palette,
                        color: Colors.tealAccent.shade100,
                        size: 28,
                      );
                    });
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: Colors.tealAccent.shade100,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () async {
                      // log out firebase
                    },
                    child: const Text(
                      'Apply color',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
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
