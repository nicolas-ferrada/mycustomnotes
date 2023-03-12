import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';
import 'package:mycustomnotes/utils/internet/check_internet_connection.dart';
import '../../data/models/note_model.dart';

class NoteService {
  // Read one note created by the user from Firebase
  static Future<Note> readOneNoteFirestore({
    required String noteId,
  }) async {
    try {
      final db = FirebaseFirestore.instance;
      bool isDeviceConnected =
          await CheckInternetConnection.checkInternetConnection();
      DocumentSnapshot<Map<String, dynamic>> note;

      if (isDeviceConnected) {
        note = await db
            .collection('note')
            .doc(noteId)
            .get(const GetOptions(source: Source.serverAndCache));
      } else {
        note = await db
            .collection('note')
            .doc(noteId)
            .get(const GetOptions(source: Source.cache));
      }

      if (note.exists) {
        return Note.fromMap(note.data()!);
      } else {
        throw Exception("Can't find the note").getMessage;
      }
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Read all notes from one user in firebase
  static Stream<List<Note>> readAllNotesFirestore({
    required String userId,
  }) async* {
    try {
      final db = FirebaseFirestore.instance;
      bool isDeviceConnected =
          await CheckInternetConnection.checkInternetConnection();
      QuerySnapshot<Map<String, dynamic>> documents;
      if (isDeviceConnected) {
        documents = await db
            .collection('note')
            .where('userId', isEqualTo: userId)
            .get(const GetOptions(source: Source.serverAndCache));
      } else {
        documents = await db
            .collection('note')
            .where('userId', isEqualTo: userId)
            .get(const GetOptions(source: Source.cache));
      }

      List<Note> notes = [];
      for (var docSnapshots in documents.docs) {
        final data = Note.fromMap(docSnapshots.data());
        notes.add(data);
      }
      yield notes;
    } catch (e) {
      throw Exception('Error reading all notes: $e');
    }
  }

  // Create a note in firebase
  static Future<void> createNoteFirestore({
    required String title,
    required String body,
    required String userId,
    required bool isFavorite,
    required int color,
  }) async {
    try {
      // References to the firestore colletion.
      final noteCollection = FirebaseFirestore.instance.collection('note');

      // Generate the document id
      final documentReference = noteCollection.doc();
      // Applies the created id documents of firestore to the noteId
      final noteId = documentReference.id;

      final note = Note(
        id: noteId,
        title: title,
        body: body,
        userId: userId,
        lastModificationDate: Timestamp.now(),
        createdDate: Timestamp.now(),
        isFavorite: isFavorite,
        color: color,
      );

      // Transform that note object into a map to store it.
      final mapNote = note.toMap();

      // Store the note object in firestore
      await documentReference.set(mapNote);
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Update a note in firebase
  static Future<void> editOneNoteFirestore({
    required noteId,
    required title,
    required body,
    required userId,
    required isFavorite,
    required int color,
    required String? youtubeUrl,
  }) async {
    try {
      // Get the current 'created date' of the note to use the same.
      final currentNote = await readOneNoteFirestore(noteId: noteId);
      final existingCreatedDate = currentNote.createdDate;

      // Create the new note to replace the other
      final note = Note(
        id: noteId,
        title: title,
        body: body,
        userId: userId,
        lastModificationDate: Timestamp.now(),
        createdDate: existingCreatedDate,
        isFavorite: isFavorite,
        color: color,
        youtubeUrl: youtubeUrl,
      );
      final db = FirebaseFirestore.instance;

      final docNote = db.collection('note').doc(noteId);

      final mapNote = note.toMap();

      await docNote.set(mapNote);
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Delete a note in firebase
  static Future<void> deleteOneNoteFirestore({
    required noteId,
  }) async {
    final db = FirebaseFirestore.instance;

    final docNote = db.collection('note').doc(noteId);

    await docNote.delete();
  }

  // Dev
  // After adding a new attribute to the model class, you need to update all other notes created.
  // Updates all documents created to add a new field to them, so stream won't return null.
  static Future<void> updateAllNotesFirestoreWithNewFields() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection('note').get();

    for (var document in snapshot.docs) {
      await document.reference
          .update({'youtubeUrl': null}); // new field: default value.
    }
  }
}
