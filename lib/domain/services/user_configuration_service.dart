import 'dart:convert';

import 'package:mycustomnotes/data/models/User/user_configuration.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserConfigurationService {
  // Get user app configuration
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
      throw Exception('Error reading user language $e').getMessage;
    }
  }

  static Future<UserConfiguration> getUserConfigurations({
    required String userId,
  }) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

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
      throw Exception('Error reading user language $e').getMessage;
    }
  }
}
