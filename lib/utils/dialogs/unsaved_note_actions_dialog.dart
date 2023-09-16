import 'package:flutter/material.dart';
import 'package:mycustomnotes/l10n/l10n_export.dart';
import 'package:mycustomnotes/utils/enums/unsaved_note_actions.dart';

class UnsavedNoteActionsDialog {
  static Future<UnsavedNoteActions?> unsavedNoteActionDialog(
      BuildContext context) {
    return showDialog<UnsavedNoteActions?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.grey.shade400,
          title: title(context),
          actions: [
            Center(
              child: Column(
                children: [
                  leaveWithoutSavingButton(context),
                  const SizedBox(
                    height: 28,
                  ),
                  saveChangesButton(context),
                  const SizedBox(
                    height: 4,
                  ),
                  cancelButton(context),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget leaveWithoutSavingButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 40),
        elevation: 5,
        backgroundColor: Colors.white,
      ),
      onPressed: () async {
        Navigator.maybePop(context, UnsavedNoteActions.leaveWithoutSaving);
      },
      child: Text(
        AppLocalizations.of(context)!.discardChanges_dialog_leaveButton,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  static Widget saveChangesButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 40),
        elevation: 10,
        backgroundColor: Colors.white,
      ),
      onPressed: () {
        Navigator.maybePop(context, UnsavedNoteActions.saveChanges);
      },
      child: Text(
        AppLocalizations.of(context)!.saveChangesButton,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  static Widget cancelButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 40),
        elevation: 10,
        backgroundColor: Colors.white,
      ),
      onPressed: () {
        Navigator.maybePop(context, UnsavedNoteActions.cancel);
      },
      child: Text(
        AppLocalizations.of(context)!.cancelButton,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  static Widget title(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade800.withOpacity(0.8),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          textAlign: TextAlign.center,
          AppLocalizations.of(context)!.discardChanges_dialog_title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
