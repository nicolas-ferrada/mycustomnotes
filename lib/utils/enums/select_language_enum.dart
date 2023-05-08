import 'package:flutter/material.dart';

import '../../l10n/l10n_export.dart';

enum SelectLanguage {
  english(lenguageId: 'EN', languageIndex: 1),
  spanish(lenguageId: 'ES', languageIndex: 2);

  const SelectLanguage({
    required this.lenguageId,
    required this.languageIndex,
  });
  final String lenguageId;
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
    }
  }
}
