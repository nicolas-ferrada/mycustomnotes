import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycustomnotes/data/models/User/user_configuration.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';
import '../../utils/internet/check_internet_connection.dart';

class UserConfigurationService {
  // Get user language
  static Future<UserConfiguration> getUserConfigurations({
    required String userId,
  }) async {
    try {
      final db = FirebaseFirestore.instance;

      late final UserConfiguration userConfiguration;

      bool isDeviceConnected =
          await CheckInternetConnection.checkInternetConnection();

      QuerySnapshot<Map<String, dynamic>> documents;

      if (isDeviceConnected) {
        documents = await db
            .collection('userConfiguration')
            .where('userId', isEqualTo: userId)
            .get(const GetOptions(source: Source.serverAndCache));
      } else {
        documents = await db
            .collection('userConfiguration')
            .where('userId', isEqualTo: userId)
            .get(const GetOptions(source: Source.cache));
      }

      if (documents.docs.isEmpty) {
        throw Exception('No user configuration found');
      } else {
        userConfiguration =
            UserConfiguration.fromMap(documents.docs.first.data());
      }

      return userConfiguration;
    } catch (e) {
      throw Exception('Error reading user language $e');
    }
  }

  static Future<void> createUserConfigurations({
    required String userId,
  }) async {
    try {
      // References to the firestore colletion.
      final userConfigurationCollection =
          FirebaseFirestore.instance.collection('userConfiguration');

      // Generate the document id
      final documentReference = userConfigurationCollection.doc();

      final userConfiguration = UserConfiguration(
        userId: userId,
        language: 'EN',
        dateTimeFormat: 'DD/MM/YYYY',
        notesView: 2,
      );

      final mapUserConfiguration = userConfiguration.toMap();

      // Store the note object in firestore
      await documentReference.set(mapUserConfiguration);
    } catch (e) {
      throw Exception("Error creating user initial configuration").getMessage;
    }
  }
}
