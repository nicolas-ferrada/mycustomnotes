import 'package:flutter/material.dart';

enum NoteColor {
  ambar,
  green,
  lightBlue,
  orange,
  pink,
  teal,
  lightRed,
}

extension GetNoteColor on NoteColor {
  Color get getColor {
    switch (this) {
      case NoteColor.ambar:
        return Colors.amber.shade300;
      case NoteColor.green:
        return Colors.green.shade300;
      case NoteColor.lightBlue:
        return Colors.lightBlue.shade300;
      case NoteColor.orange:
        return Colors.orange.shade400;
      case NoteColor.pink:
        return Colors.pinkAccent.shade100;
      case NoteColor.teal:
        return Colors.tealAccent.shade100;
      case NoteColor.lightRed:
        return Colors.red.shade400;
      default:
        return Colors.grey;
    }
  }
}

class NoteColorOperations {
  static int getNumberFromColor({required Color color}) {
    if (color == NoteColor.ambar.getColor) {
      return 1;
    } else if (color == NoteColor.green.getColor) {
      return 2;
    } else if (color == NoteColor.lightBlue.getColor) {
      return 3;
    } else if (color == NoteColor.orange.getColor) {
      return 4;
    } else if (color == NoteColor.pink.getColor) {
      return 5;
    } else if (color == NoteColor.teal.getColor) {
      return 6;
    } else if (color == NoteColor.lightRed.getColor) {
      return 7;
    } else {
      return 0;
    }
  }

  static Color getColorFromNumber({required int colorNumber}) {
    switch (colorNumber) {
      case 1:
        return NoteColor.ambar.getColor;
      case 2:
        return NoteColor.green.getColor;
      case 3:
        return NoteColor.lightBlue.getColor;
      case 4:
        return NoteColor.orange.getColor;
      case 5:
        return NoteColor.pink.getColor;
      case 6:
        return NoteColor.teal.getColor;
      case 7:
        return NoteColor.lightRed.getColor;
      default:
        return Colors.grey;
    }
  }

  static Future<Color> pickNoteColorDialog({
    required BuildContext context,
  }) async {
    late Color noteColor;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          contentPadding: const EdgeInsets.all(12),
          backgroundColor: Colors.grey,
          title: const Center(
            child: Text("Pick the note's color"),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // YELLOW COLOR
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = NoteColor.ambar.getColor;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: NoteColor.ambar.getColor,
                  ),
                ),
              ),
              // GREEN COLOR
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = NoteColor.green.getColor;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: NoteColor.green.getColor,
                  ),
                ),
              ),
              // BLUE COLOR
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = NoteColor.lightBlue.getColor;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: NoteColor.lightBlue.getColor,
                  ),
                ),
              ),
              // ORANGE COLOR
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = NoteColor.orange.getColor;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: NoteColor.orange.getColor,
                  ),
                ),
              ),
              // PINK COLOR
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = NoteColor.pink.getColor;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: NoteColor.pink.getColor,
                  ),
                ),
              ),
              // TEAL COLOR
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = NoteColor.teal.getColor;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: NoteColor.teal.getColor,
                  ),
                ),
              ),
              // LIGHT RED COLOR
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    noteColor = NoteColor.lightRed.getColor;
                    Navigator.maybePop(context);
                  },
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.circle,
                    size: 38,
                    color: NoteColor.lightRed.getColor,
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
                      backgroundColor: Colors.white,
                    ),
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
}
