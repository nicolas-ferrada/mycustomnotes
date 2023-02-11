import 'package:flutter/material.dart';

class NotesColors {
  // Pick the correct color using an int value
  static Color selectNoteColor(int intNoteColor) {
    Color noteColor = Colors.grey;
    switch (intNoteColor) {
      case 1:
        {
          noteColor = Colors.amber.shade300;
        }
        return noteColor;
      case 2:
        {
          noteColor = Colors.green.shade300;
        }
        return noteColor;
      case 3:
        {
          noteColor = Colors.lightBlue.shade300;
        }
        return noteColor;
      case 4:
        {
          noteColor = Colors.orange.shade300;
        }
        return noteColor;
      case 5:
        {
          noteColor = Colors.pinkAccent.shade100;
        }
        return noteColor;
      case 6:
        {
          noteColor = Colors.tealAccent.shade100;
        }
        return noteColor;
      default:
        {
          noteColor = Colors.grey;
        }
        return noteColor;
    }
  }

  static Future<int> colorIntPickNoteDialog({
    required int noteColor,
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.grey,
          title: const Center(
            child: Text("Pick the note's color"),
          ),
          content: Row(
            children: [
              // Yellow
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = 1;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: Colors.amber.shade300,
                  ),
                ),
              ),
              // Green
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = 2;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: Colors.green.shade300,
                  ),
                ),
              ),
              // Blue
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = 3;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: Colors.lightBlue.shade300,
                  ),
                ),
              ),
              // Orange
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = 4;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: Colors.orange.shade300,
                  ),
                ),
              ),
              // Pink
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = 5;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: Colors.pinkAccent.shade100,
                  ),
                ),
              ),
              // Sky-blue
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = 6;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: Colors.tealAccent.shade100,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: Column(
                children: [
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
    return noteColor;
  }

  static Future<int> callColorIntPickNoteDialog({
    required int noteColor,
    required BuildContext context,
  }) async {
    return await NotesColors.colorIntPickNoteDialog(
      noteColor: noteColor,
      context: context,
    );
  }
}
