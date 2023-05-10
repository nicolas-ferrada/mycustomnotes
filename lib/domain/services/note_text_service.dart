import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/Note/note_text_model.dart';
import '../../utils/extensions/formatted_message.dart';
import '../../utils/internet/check_internet_connection.dart';

class NoteTextService {
  // Read all text notes from one user in firebase
  static Stream<List<NoteText>> readAllNotesText({
    required String userId,
  }) async* {
    try {
      final db = FirebaseFirestore.instance;

      bool isDeviceConnected =
          await CheckInternetConnection.checkInternetConnection();

      QuerySnapshot<Map<String, dynamic>> documents;

      if (isDeviceConnected) {
        documents = await db
            .collection('noteText')
            .where('userId', isEqualTo: userId)
            .get(const GetOptions(source: Source.serverAndCache));
      } else {
        documents = await db
            .collection('noteText')
            .where('userId', isEqualTo: userId)
            .get(const GetOptions(source: Source.cache));
      }

      List<NoteText> textNotes = [];
      for (var docSnapshots in documents.docs) {
        final data = NoteText.fromMap(docSnapshots.data());
        textNotes.add(data);
      }
      yield textNotes;
    } catch (e) {
      throw Exception('Error reading all notes: $e');
    }
  }

  // Create a note in firebase
  static Future<void> createNoteText({
    required String title,
    required String body,
    required String userId,
    required bool isFavorite,
    required int color,
    String? url,
  }) async {
    try {
      // References to the firestore colletion.
      final noteCollection = FirebaseFirestore.instance.collection('noteText');

      // Generate the document id
      final documentReference = noteCollection.doc();
      // Applies the created id documents of firestore to the noteId
      final noteId = documentReference.id;

      final noteText = NoteText(
        id: noteId,
        title: title,
        body: body,
        userId: userId,
        lastModificationDate: Timestamp.now(),
        createdDate: Timestamp.now(),
        isFavorite: isFavorite,
        color: color,
        url: url
      );

      // Transform that note object into a map to store it.
      final mapNote = noteText.toMap();

      // Store the note object in firestore
      await documentReference.set(mapNote);
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .removeExceptionWord;
    }
  }

  // Update a note in firebase
  static Future<void> editNoteText({required NoteText note}) async {
    try {
      // Create the new note to replace the other
      final finalNoteText = NoteText(
        id: note.id,
        title: note.title,
        body: note.body,
        userId: note.userId,
        lastModificationDate: Timestamp.now(),
        createdDate: note.createdDate,
        isFavorite: note.isFavorite,
        color: note.color,
        url: note.url,
      );
      final db = FirebaseFirestore.instance;

      final docNote = db.collection('noteText').doc(note.id);

      final mapNote = finalNoteText.toMap();

      await docNote.set(mapNote);
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .removeExceptionWord;
    }
  }

  // Delete a note in firebase
  static Future<void> deleteNoteText({
    required noteId,
  }) async {
    final db = FirebaseFirestore.instance;

    final docNote = db.collection('noteText').doc(noteId);

    await docNote.delete();
  }

  // Read one note created by the user from Firebase (Not used at this moment)
  // static Future<Note> readOneNote({
  //   required String noteId,
  // }) async {
  //   try {
  //     final db = FirebaseFirestore.instance;

  //     // True if device it's connected to any network, false if it is not
  //     bool isDeviceConnected =
  //         await CheckInternetConnection.checkInternetConnection();

  //     // Used to store the incoming note
  //     DocumentSnapshot<Map<String, dynamic>> note;

  //     if (isDeviceConnected) {
  //       note = await db
  //           .collection('note')
  //           .doc(noteId)
  //           .get(const GetOptions(source: Source.serverAndCache));
  //     } else {
  //       note = await db
  //           .collection('note')
  //           .doc(noteId)
  //           .get(const GetOptions(source: Source.cache));
  //     }

  //     if (note.exists) {
  //       return Note.fromMap(note.data()!);
  //     } else {
  //       throw Exception("Can't find the note").getMessage;
  //     }
  //   } catch (unexpectedException) {
  //     throw Exception("There is an unexpected error:\n$unexpectedException")
  //         .getMessage;
  //   }
  // }

  // Dev
  // After adding a new attribute to the model class, you need to update all other notes created.
  // Updates all documents created to add a new field to them, so stream won't return null.
  // static Future<void> updateAllNotesFirestoreWithNewFields() async {
  //   final db = FirebaseFirestore.instance;
  //   final snapshot = await db.collection('note').get();

  //   for (var document in snapshot.docs) {
  //     await document.reference
  //         .update({'youtubeUrl': null}); // new field: default value.
  //   }
  // }
}
