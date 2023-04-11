import 'package:flutter/material.dart';

class UserConfigurationNotesView {
  static Future<int?> changeNotesView({
    required BuildContext context,
    required int userConfigurationNotesView,
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
                                Icons.format_list_numbered,
                                size: 46,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  '1x1',
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
                                Icons.view_comfy_alt,
                                size: 46,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  '2x2',
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
                                Icons.grid_3x3,
                                size: 46,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  '3x3',
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      color: Colors.grey.shade800.withOpacity(0.9),
                      child: Text(
                        'Current view selected: ${userConfigurationNotesView}x$userConfigurationNotesView',
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
}
