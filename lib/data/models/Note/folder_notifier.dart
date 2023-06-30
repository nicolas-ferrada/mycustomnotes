import 'package:flutter/material.dart';

class FolderNotifier with ChangeNotifier {
  void refreshFolders() {
    notifyListeners();
  }
}
