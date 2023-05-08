import 'package:flutter/cupertino.dart';

import '../../l10n/l10n_export.dart';

enum NotesView {
  small(1, 'Small'),
  split(2, 'Split'),
  large(3, 'Large');

  const NotesView(this.notesViewId, this.notesViewName);
  final int notesViewId;
  final String notesViewName;

  String noteViewName({
    required BuildContext context,
    required NotesView currentView,
  }) {
    switch (currentView) {
      case NotesView.small:
        return AppLocalizations.of(context)!
            .smallNotesViewOption_drawerDialog_homePage;
      case NotesView.split:
        return AppLocalizations.of(context)!
            .splitNotesViewOption_drawerDialog_homePage;
      case NotesView.large:
        return AppLocalizations.of(context)!
            .largeNotesViewOption_drawerDialog_homePage;
    }
  }
}
