import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/Note/note_notifier.dart';
import '../../domain/services/note_service.dart';
import '../exceptions/exceptions_alert_dialog.dart';
import '../internet/check_internet_connection.dart';

class DeleteNoteConfirmation {
  // Delete note dialog
  static Future<void> deleteNoteDialog({
    required BuildContext context,
    required String noteId,
  }) {
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
                      // Check if device it's connected to any network
                      bool isDeviceConnected = await CheckInternetConnection
                          .checkInternetConnection();
                      int waitingConnection = 5;

                      // If device is connected, wait 5 seconds, if is not connected, dont wait.
                      if (isDeviceConnected) {
                        waitingConnection = 5;
                      } else {
                        waitingConnection = 0;
                      }
                      try {
                        // Delete a specified note
                        await NoteService.deleteNote(noteId: noteId)
                            .timeout(
                          Duration(seconds: waitingConnection),
                          onTimeout: () {
                            Provider.of<NoteNotifier>(context, listen: false)
                                .refreshNotes();
                            Navigator.pop(context);
                            Navigator.maybePop(context);
                          },
                        );
                        if (context.mounted) {
                          Provider.of<NoteNotifier>(context, listen: false)
                              .refreshNotes();
                          Navigator.pop(context);
                          Navigator.maybePop(context);
                        }
                      } catch (errorMessage) {
                        if (context.mounted) {
                          ExceptionsAlertDialog.showErrorDialog(
                              context, errorMessage.toString());
                        }
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
