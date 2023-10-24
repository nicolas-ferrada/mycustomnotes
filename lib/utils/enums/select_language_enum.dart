import 'package:flutter/material.dart';

import '../../l10n/l10n_export.dart';

enum SelectLanguage {
  english(languageId: 'en', languageIndex: 1),
  spanish(languageId: 'es', languageIndex: 2),
  german(languageId: 'de', languageIndex: 3);

  const SelectLanguage({
    required this.languageId,
    required this.languageIndex,
  });
  final String languageId;
  final int languageIndex;

  String languageName({
    required BuildContext context,
    required SelectLanguage currentLanguage,
  }) {
    switch (currentLanguage) {
      case SelectLanguage.english:
        return AppLocalizations.of(context)!
            .languageEnglishOption_drawerDialog_homePage;
      case SelectLanguage.spanish:
        return AppLocalizations.of(context)!
            .languageSpanishOption_drawerDialog_homePage;
      case SelectLanguage.german:
        return AppLocalizations.of(context)!
            .languageGermanOption_drawerDialog_homePage;
    }
  }
}
