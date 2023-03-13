import 'package:flutter/material.dart';

class NoteNotifier with ChangeNotifier {
  void refreshNotes() {
    notifyListeners();
  }
}
