import 'package:flutter/material.dart';

enum NoteColor {
  ambar(colorId: 1, getColor: Color.fromRGBO(255, 213, 79, 1)),
  green(colorId: 2, getColor: Color.fromRGBO(129, 199, 132, 1)),
  lightBlue(colorId: 3, getColor: Color.fromRGBO(79, 195, 247, 1)),
  orange(colorId: 4, getColor: Color.fromRGBO(255, 167, 38, 1)),
  pink(colorId: 5, getColor: Color.fromRGBO(255, 128, 171, 1)),
  teal(colorId: 6, getColor: Color.fromRGBO(167, 255, 235, 1)),
  lightRed(colorId: 7, getColor: Color.fromRGBO(239, 83, 80, 1));

  const NoteColor({
    required this.colorId,
    required this.getColor,
  });
  final int colorId;
  final Color getColor;
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
}
