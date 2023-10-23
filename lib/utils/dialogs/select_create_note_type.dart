import 'package:flutter/material.dart';
import '../../l10n/l10n_export.dart';
import '../styles/dialog_title_style.dart';

import '../../presentation/routes/routes.dart';

class SelectCreateNoteType {
  static Future<void> noteDetailsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.grey.shade400,
          title: DialogTitleStyle(
            title: AppLocalizations.of(context)!.newNoteTitle_dialog_homePage,
          ),
          content: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                noteText(context),
                noteTasks(context),
              ],
            ),
          ),
          actions: [
            cancelButton(context),
          ],
        );
      },
    );
  }

  static Widget noteText(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: 150,
        width: 200,
        child: Card(
          elevation: 10,
          color: Colors.grey.shade800.withOpacity(0.9),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, noteTextCreatePageRoute);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.text_snippet,
                    size: 44,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!
                        .newNoteTextNoteOption_dialog_homePage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget noteTasks(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: 150,
        width: 200,
        child: Card(
          elevation: 10,
          color: Colors.grey.shade800.withOpacity(0.9),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, noteTasksCreatePageRoute);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.view_list,
                    size: 44,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!
                        .newNoteTasksNoteOption_dialog_homePage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Center cancelButton(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Close button
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
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
