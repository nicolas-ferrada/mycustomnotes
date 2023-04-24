import 'dart:convert';

import 'package:mycustomnotes/data/models/User/user_configuration.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserConfigurationService {
  // Only used for the first time, on account creation/email verification.
  static Future<void> createUserConfigurations({
    required String userId,
  }) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      final UserConfiguration userConfiguration = UserConfiguration(
        userId: userId,
        language: 'EN',
        dateTimeFormat: 'DD/MM/YYYY',
        notesView: 2,
      );

      final userConfigurationJson = json.encode(userConfiguration.toMap());

      await preferences.setString(userId, userConfigurationJson);
    } catch (e) {
      throw Exception('Error creating the user configuration $e').getMessage;
    }
  }

  static Future<UserConfiguration> getUserConfigurations({
    required String userId,
  }) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.reload();

      late final UserConfiguration userConfiguration;

      final String? userConfigurationJson = preferences.getString(userId);

      if (userConfigurationJson == null) {
        // if the config does not exists, create one
        await createUserConfigurations(userId: userId);
      } else {
        userConfiguration =
            UserConfiguration.fromMap(json.decode(userConfigurationJson));
      }

      return userConfiguration;
    } catch (e) {
      throw Exception('Error reading the user configuration $e').getMessage;
    }
  }

  static Future<void> editUserConfigurations({
    required String userId,
    String? language,
    String? dateTimeFormat,
    int? notesView,
  }) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.reload();

      // Get the current configuration to fill the not given fields of the new configuration.
      final UserConfiguration currentConfiguration =
          await UserConfigurationService.getUserConfigurations(userId: userId);

      // The new edited version of the configurations, if one field was not given, the rest is
      // equal to the previous versions.
      final UserConfiguration newConfiguration = UserConfiguration(
        userId: userId,
        language: language ?? currentConfiguration.language,
        dateTimeFormat: dateTimeFormat ?? currentConfiguration.dateTimeFormat,
        notesView: notesView ?? currentConfiguration.notesView,
      );

      final userConfigurationJson = json.encode(newConfiguration.toMap());

      await preferences.setString(userId, userConfigurationJson);
    } catch (e) {
      throw Exception('Error editing the user configurations $e').getMessage;
    }
  }
}
