import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/note_model.dart';

class CloudDatabaseHelper {
  // Create a note in firebase
  static Future<void> createNoteCloudDB(Note note) async {
    // References to the firestore colletion.
    final docUser = FirebaseFirestore.instance.collection('note');

    // Transform that note object into a map to store it.
    final mapNote = note.toMap();

    // Store the Note map in firestore
    await docUser.add(mapNote);
  }
}
