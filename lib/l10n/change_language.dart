import 'package:flutter/material.dart';
import 'package:mycustomnotes/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n_locale_provider.dart';

class ChangeLanguage {
  // Get language for when app starts
  static Future<String> getLanguage() async {
    late final String language;

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.reload();

    final String? languageFromDB = preferences.getString('language');

    if (languageFromDB != null) {
      language = languageFromLocalDb(languageFromDB: languageFromDB);
    } else {
      language = languageFromDevice();
    }

    return language;
  }

  static String languageFromLocalDb({
    required String languageFromDB,
  }) {
    if (L10n.all.contains(Locale(languageFromDB))) {
      return languageFromDB;
    } else {
      return 'en'; // Saved language is not support by the app
    }
  }

  static String languageFromDevice() {
    String systemLocale =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    if (L10n.all.contains(Locale(systemLocale))) {
      return systemLocale;
    } else {
      return 'en'; // System language is not supported by the app
    }
  }

  // Change language in app
  static Future<void> changeLanguage({
    required BuildContext context,
    required String languageId,
  }) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      // Save the language in the db
      await preferences.setString('language', languageId);
      // Set the language to see the changes in the app
      if (context.mounted) {
        final provider =
            Provider.of<L10nLocaleProvider>(context, listen: false);
        provider.setLocale(Locale(languageId));
      } else {
        throw Exception();
      }
    } catch (_) {
      throw Exception();
    }
  }
}
