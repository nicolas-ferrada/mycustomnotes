import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycustomnotes/extensions/formatted_message.dart';
import '../models/note_model.dart';

class NoteService {
  // Read one note created by the user from Firebase
  static Future<Note> readOneNoteFirestore({
    required String noteId,
  }) async {
    try {
      final db = FirebaseFirestore.instance;
      final note = await db.collection('note').doc(noteId).get();

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
      final documents =
          await db.collection('note').where('userId', isEqualTo: userId).get();
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

  // Update if note it's favorite on dispose note detail
  static Future<void> updateNoteFavoriteDispose({
    required String noteId,
    required bool isFavorite,
  }) async {
    try {
      final db = FirebaseFirestore.instance;

      db.collection('note').doc(noteId).update({'isFavorite': isFavorite});
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // After adding a new attribute to the model class, you need to update all other notes created.
  // Updates all documents created to add a new field to them, so stream won't return null.
  static Future<void> updateAllNotesFirestoreWithNewFields() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection('note').get();

    for (var document in snapshot.docs) {
      await document.reference
          .update({'isFavorite': false}); // new field: default value.
    }
  }
}
