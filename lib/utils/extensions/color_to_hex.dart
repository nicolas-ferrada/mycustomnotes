import 'package:flutter/material.dart';

// Color class to string hex (used for exporting user data)
extension HexColor on Color {
  String toHex({bool leadingHashSign = false}) =>
      '${leadingHashSign ? '#' : ''}'
              '${red.toRadixString(16).padLeft(2, '0')}'
              '${green.toRadixString(16).padLeft(2, '0')}'
              '${blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
}
