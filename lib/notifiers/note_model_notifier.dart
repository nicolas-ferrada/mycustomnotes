import 'package:flutter/cupertino.dart';

class NoteModelNotifier extends ChangeNotifier {
  void refreshNote() {
    notifyListeners();
  }
}
