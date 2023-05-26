import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n_locale_provider.dart';

class ChangeLanguage {
  // Get language for when app starts
  static Future<String> getLanguage() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.reload();

    final String? languageFromDB = preferences.getString('language');

    if (languageFromDB != null) {
      return languageFromDB;
    } else {
      String systemLocale =
          WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      return systemLocale;
    }
  }

  // Change language in app
  static Future<void> changeLanguage({
    required BuildContext context,
    required String language,
  }) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      // If the language given is EN or ES, take it, otherwise just use EN
      final String finalLanguage =
          (language == 'en' || language == 'es') ? language : 'en';
      // Save the language in the db
      await preferences.setString('language', finalLanguage);
      // Set the language to see the changes in the app
      if (context.mounted) {
        final provider =
            Provider.of<L10nLocaleProvider>(context, listen: false);
        provider.setLocale(Locale(language));
      } else {
        throw Exception();
      }
    } catch (_) {
      throw Exception();
    }
  }
}
