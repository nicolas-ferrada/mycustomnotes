import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/note_model.dart';
import '../formatters/date_formatter.dart';

class NotesDetails {
  // Show note detail
  static Future<void> noteDetailsDialog(BuildContext context, Note note) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.grey,
          title: const Center(
            child: Text('Note details'),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Creation date:',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                DateFormatter.showDateFormattedAllFields(note.createdDate),
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(
                height: 22,
              ),
              const Text(
                'Last modification date:',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              Text(
                DateFormatter.showDateFormattedAllFields(
                    note.lastModificationDate),
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  // Close button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: const Text(
                      'Close',
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
