import 'package:flutter/material.dart';

import '../../presentation/routes/routes.dart';

class SelectCreateNoteType {
  static Future<void> noteDetailsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
          title: const Center(
            child: Text('Note type'),
          ),
          content: SizedBox(
            child: Row(
              children: [
                Flexible(
                  child: Card(
                    child: ListTile(
                      title: const Text('Text note'),
                      onTap: () {
                        Navigator.pushNamed(context, noteTextCreatePageRoute);
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Card(
                    child: ListTile(
                      title: const Text('Tasks note'),
                      onTap: () {
                        Navigator.pushNamed(context, noteTasksCreatePageRoute);
                      },
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
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: const Text(
                      'Cancel note creation',
                      style: TextStyle(color: Colors.black),
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
