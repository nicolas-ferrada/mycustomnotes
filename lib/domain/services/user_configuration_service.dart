import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mycustomnotes/data/models/User/user_configuration.dart';
import 'package:mycustomnotes/l10n/l10n_export.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/enums/last_modification_date_formats_enum.dart';
import '../../utils/enums/notes_view_enum.dart';

class UserConfigurationService {
  // Only used for the first time, on account creation/email verification.
  static Future<UserConfiguration> createUserConfigurations({
    required String userId,
    required BuildContext context,
  }) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      if (context.mounted) {
        final UserConfiguration userConfiguration = UserConfiguration(
          userId: userId,
          dateTimeFormat: LastModificationDateFormat.dayMonthYear.value +
              LastModificationTimeFormat.hours24.value,
          notesView: NotesView.small.notesViewId,
        );

        final userConfigurationJson = json.encode(userConfiguration.toMap());

        await preferences.setString(userId, userConfigurationJson);

        return userConfiguration;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(
              AppLocalizations.of(context)!.creating_dialog_userConfiguration)
          .removeExceptionWord;
    }
  }

  static Future<UserConfiguration> getUserConfigurations({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.reload();

      late final UserConfiguration userConfiguration;

      final String? userConfigurationJson = preferences.getString(userId);

      if (userConfigurationJson == null && context.mounted) {
        // the config does not exists, create one and then get it
        userConfiguration =
            await createUserConfigurations(userId: userId, context: context);
      } else {
        // the config exists, get it
        userConfiguration =
            UserConfiguration.fromMap(json.decode(userConfigurationJson!));
      }

      return userConfiguration;
    } catch (e) {
      throw Exception(
              AppLocalizations.of(context)!.reading_dialog_userConfiguration)
          .removeExceptionWord;
    }
  }

  static Future<void> editUserConfigurations({
    required BuildContext context,
    required String userId,
    String? dateTimeFormat,
    int? notesView,
  }) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.reload();

      // Get the current configuration to fill the not given fields of the new configuration.
      if (context.mounted) {
        final UserConfiguration currentConfiguration =
            await UserConfigurationService.getUserConfigurations(
                userId: userId, context: context);

        // The new edited version of the configurations, if one field was not given, the rest is
        // equal to the previous versions.
        final UserConfiguration newConfiguration = UserConfiguration(
          userId: userId,
          dateTimeFormat: dateTimeFormat ?? currentConfiguration.dateTimeFormat,
          notesView: notesView ?? currentConfiguration.notesView,
        );

        final userConfigurationJson = json.encode(newConfiguration.toMap());

        await preferences.setString(userId, userConfigurationJson);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(
              AppLocalizations.of(context)!.editing_dialog_userConfiguration)
          .removeExceptionWord;
    }
  }
}
