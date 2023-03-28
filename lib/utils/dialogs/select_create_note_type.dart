import 'package:flutter/material.dart';

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
              child: const Text(
                'Note type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
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
                    color: Colors.grey.shade800.withOpacity(0.9),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, noteTextCreatePageRoute);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(height: 8),
                          Icon(
                            Icons.text_snippet,
                            size: 46,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Text Note',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Card(
                    color: Colors.grey.shade800.withOpacity(0.9),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, noteTasksCreatePageRoute);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(height: 8),
                          Icon(
                            Icons.view_list,
                            size: 46,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Tasks Note',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
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
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.grey.shade800.withOpacity(0.9)),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: const Text(
                      'Cancel note creation',
                      style: TextStyle(
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
