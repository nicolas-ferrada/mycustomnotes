import 'package:flutter/material.dart';

import '../../data/models/User/user_configuration.dart';
import '../icons/notes_view_icons_icons.dart';

class UserConfigurationNotesView {
  static Future<int?> changeNotesView({
    required BuildContext context,
    required UserConfiguration userConfiguration,
  }) async {
    int? userSelectedNotesViewNumber;
    userSelectedNotesViewNumber = await showDialog<int>(
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
                'Notes view',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Card(
                        elevation: 10,
                        color: Colors.grey.shade800.withOpacity(0.9),
                        child: InkWell(
                          onTap: () {
                            userSelectedNotesViewNumber = 1;
                            Navigator.of(context)
                                .pop(userSelectedNotesViewNumber);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 8),
                              Icon(
                                NotesViewIcons.smallList,
                                size: 38,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Small',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
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
                            userSelectedNotesViewNumber = 2;
                            Navigator.of(context)
                                .pop(userSelectedNotesViewNumber);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 8),
                              Icon(
                                NotesViewIcons.splitList,
                                size: 38,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Split',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
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
                            userSelectedNotesViewNumber = 3;
                            Navigator.of(context)
                                .pop(userSelectedNotesViewNumber);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 8),
                              Icon(
                                Icons.square,
                                size: 42,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Large',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      color: Colors.grey.shade800.withOpacity(0.9),
                      child: Text(
                        'Current view selected: ${getUserCurrentSelectedView(userConfiguration: userConfiguration)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
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
                    child: const Text(
                      'Cancel',
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
    return userSelectedNotesViewNumber;
  }

  static String getUserCurrentSelectedView({
    required UserConfiguration userConfiguration,
  }) {
    int notesView = userConfiguration.notesView;

    switch (notesView) {
      case 1:
        return 'Small';
      case 2:
        return 'Split';
      case 3:
        return 'Large';
      default:
        return 'Error';
    }
  }
}
