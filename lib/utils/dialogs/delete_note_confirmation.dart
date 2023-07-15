import 'package:flutter/material.dart';
import 'package:mycustomnotes/data/models/Note/note_tasks_model.dart';
import 'package:mycustomnotes/l10n/l10n_export.dart';
import 'package:provider/provider.dart';

import '../../data/models/Note/note_notifier.dart';
import '../../data/models/Note/note_text_model.dart';
import '../../domain/services/note_tasks_service.dart';
import '../../domain/services/note_text_service.dart';
import '../exceptions/exceptions_alert_dialog.dart';
import '../internet/check_internet_connection.dart';
import '../styles/dialog_subtitle_style.dart';
import '../styles/dialog_title_style.dart';

class DeleteNoteConfirmation {
  // Delete note dialog
  static Future<void> deleteNoteDialog({
    required BuildContext context,
    required dynamic note,
    bool? editingFromSearchBar,
    bool? isBeingEditedInFolder,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: const Color.fromARGB(220, 250, 215, 90),
          title: DialogTitleStyle(
            title: AppLocalizations.of(context)!.deleteNote_dialog_title,
          ),
          content: DialogSubtitleStyle(
            subtitle: AppLocalizations.of(context)!.deleteNote_dialog_infoText,
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  // Delete button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.white,
                    ),
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
                        if (note is NoteTasks) {
                          if (context.mounted) {
                            await NoteTasksService.deleteNoteTasks(
                                    context: context, noteId: note.id)
                                .timeout(
                              Duration(seconds: waitingConnection),
                              onTimeout: () {
                                deleteOperations(
                                  context: context,
                                  note: note,
                                  editingFromSearchBar: editingFromSearchBar,
                                  isBeingEditedInFolder: editingFromSearchBar,
                                );
                              },
                            );
                          }
                        } else if (note is NoteText) {
                          if (context.mounted) {
                            await NoteTextService.deleteNoteText(
                                    noteId: note.id, context: context)
                                .timeout(
                              Duration(seconds: waitingConnection),
                              onTimeout: () {
                                deleteOperations(
                                  context: context,
                                  note: note,
                                  editingFromSearchBar: editingFromSearchBar,
                                  isBeingEditedInFolder: editingFromSearchBar,
                                );
                              },
                            );
                          }
                        } else {
                          if (context.mounted) {
                            throw Exception(AppLocalizations.of(context)!
                                .deleteNote_dialog_exceptionNoteNotFound);
                          }
                        }
                        if (context.mounted) {
                          deleteOperations(
                            context: context,
                            note: note,
                            editingFromSearchBar: editingFromSearchBar,
                            isBeingEditedInFolder: isBeingEditedInFolder,
                          );
                        }
                      } catch (errorMessage) {
                        if (context.mounted) {
                          ExceptionsAlertDialog.showErrorDialog(
                              context: context,
                              errorMessage: errorMessage.toString());
                        }
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .deleteNote_dialog_deleteButton,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  // Cancel button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.cancelButton,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static deleteOperations({
    required BuildContext context,
    bool? editingFromSearchBar,
    bool? isBeingEditedInFolder,
    required dynamic note,
  }) {
    Provider.of<NoteNotifier>(context, listen: false).refreshNotes();
    if (editingFromSearchBar != null && editingFromSearchBar == true) {
      Navigator.maybePop(context).then((_) =>
          Navigator.maybePop(context).then((_) => Navigator.maybePop(context)));
    } else {
      Navigator.maybePop(context).then((_) {
        Navigator.maybePop(context).then((value) {
          Map<String, dynamic> arguments = {
            'newNote': note,
            'isBeingEditedInFolder': isBeingEditedInFolder,
            'delete': true,
          };
          Navigator.maybePop(context, arguments);
        });
      });
    }
  }
}
