import 'package:flutter/material.dart';
import 'package:mycustomnotes/l10n/l10n_export.dart';

import '../../presentation/routes/routes.dart';

class SelectCreateNoteType {
  static Future<void> noteDetailsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: const Color.fromRGBO(250, 216, 90, 0.8),
          title: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.grey.shade800.withOpacity(0.9),
              child: Text(
                textAlign: TextAlign.center,
                AppLocalizations.of(context)!.newNoteTitle_dialog_homePage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          content: SizedBox(
            child: Row(
              children: [
                Flexible(
                  child: Card(
                    elevation: 10,
                    color: Colors.grey.shade800.withOpacity(0.9),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, noteTextCreatePageRoute);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 8),
                          const Icon(
                            Icons.text_snippet,
                            size: 46,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .newNoteTextNoteOption_dialog_homePage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Card(
                    elevation: 10,
                    color: Colors.grey.shade800.withOpacity(0.9),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, noteTasksCreatePageRoute);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 8),
                          const Icon(
                            Icons.view_list,
                            size: 46,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .newNoteTasksNoteOption_dialog_homePage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  // Close button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.grey.shade800.withOpacity(0.9)),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.cancelButton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
