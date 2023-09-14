import 'dart:convert';

import 'package:flutter/material.dart';
import '../../data/models/User/user_configuration.dart';
import '../../l10n/l10n_export.dart';
import '../../utils/extensions/formatted_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/enums/last_modification_date_formats_enum.dart';
import '../../utils/enums/notes_view_enum.dart';

class UserConfigurationService {
  // Only used for the first time, on account creation/email verification.
  static Future<UserConfiguration> createUserConfigurations({
    required String userId,
  }) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      final UserConfiguration userConfiguration = UserConfiguration(
        userId: userId,
        dateTimeFormat: LastModificationDateFormat.dayMonthYear.value +
            LastModificationTimeFormat.hours24.value,
        notesView: NotesView.small.notesViewId,
        areNotesBeingVisible: true,
      );

      final userConfigurationJson = json.encode(userConfiguration.toMap());

      await preferences.setString(userId, userConfigurationJson);

      return userConfiguration;
    } catch (_) {
      throw Exception('Error: Restart or reinstall the app')
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
        userConfiguration = await createUserConfigurations(userId: userId);
      } else {
        // the config exists, get it
        try {
          userConfiguration =
              UserConfiguration.fromMap(json.decode(userConfigurationJson!));
        } catch (_) {
          // if fails loading the config, just reset it

          userConfiguration = await createUserConfigurations(userId: userId);
        }
      }

      return userConfiguration;
    } catch (e) {
      if (!context.mounted) throw Exception();
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
    bool? areNotesBeingVisible,
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
          areNotesBeingVisible:
              areNotesBeingVisible ?? currentConfiguration.areNotesBeingVisible,
        );

        final userConfigurationJson = json.encode(newConfiguration.toMap());

        await preferences.setString(userId, userConfigurationJson);
      } else {
        throw Exception();
      }
    } catch (e) {
      if (!context.mounted) throw Exception();
      throw Exception(
              AppLocalizations.of(context)!.editing_dialog_userConfiguration)
          .removeExceptionWord;
    }
  }
}
