import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as log;
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

  // Read all notes
  static Stream<List<Note>> readAllNotesCloudDB() async* {
    try {
      final db = FirebaseFirestore.instance;
      final collectionNote = db.collection('note');
      final snapshot = await collectionNote.get();
      List<Note> notes = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshots
          in snapshot.docs) {
        final data = Note.fromMap(docSnapshots.data());
        log.log(data.toString());
        notes.add(data);
      }
      yield notes;
    } catch (e) {
      throw Exception('Error reading all notes: $e');
    }
  }
}
