import 'package:flutter/material.dart';
import 'l10n.dart';

class L10nLocaleProvider extends ChangeNotifier {
  final String language;
  Locale? _locale;

  L10nLocaleProvider({
    required this.language,
  }) {
    _locale = Locale(language);
  }

  Locale? get locale => _locale;

  void setLocale(Locale locale) async {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }
}
