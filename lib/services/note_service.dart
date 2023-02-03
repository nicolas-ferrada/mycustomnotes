import 'package:mycustomnotes/extensions/formatted_message.dart';
import '../database/firebase/cloud_database_helper.dart';
import '../database/sqlite/local_database_helper.dart';
import '../models/note_model.dart';

class NoteService {
  // Read one note from Firebase

  // Read one note from sqlite and return it
  static Future<Note> readOneNoteDB({
    required int noteId,
  }) async {
    try {
      final Note fromDBNote =
          await LocalDatabaseHelper.instance.readOneNoteDB(noteId);
      return fromDBNote;
    } catch (unexpectedException) {
      throw Exception("There is a unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Read all notes firebase

  // Read all notes sqlite and returns them.
  static Future<List<Note>> readAllNotesDB({
    required String userId,
  }) async {
    try {
      final List<Note> allNotesFromDB =
          await LocalDatabaseHelper.instance.readAllNotesDB(userId);
      return allNotesFromDB;
    } catch (unexpectedException) {
      throw Exception("There is a unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Create a note in firebase
  static Future<void> createNoteCloudFirestore({
    required String title,
    required String body,
    required String userId,
    required int noteId,
  }) async {
    try {
      final note = Note(
        title: title,
        body: body,
        userId: userId,
        id: noteId,
      );
      await CloudDatabaseHelper.createNoteCloudDB(note);
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Create note in sqlite
  static Future<int> createNoteDB({
    required String title,
    required String body,
    required String userId,
  }) async {
    try {
      final note = Note(title: title, body: body, userId: userId);
      final int noteId = await LocalDatabaseHelper.instance.createNoteDB(note);
      return noteId;
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Delete a note in firebase

  // Delete a note in sqlite
  static Future<void> deleteNote({required int noteId}) async {
    try {
      LocalDatabaseHelper.instance.deleteNoteDB(noteId);
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Update a note in firebase

  // Update a note in sqlite
  static Future<void> editNote({
    required String title,
    required String body,
    required int id,
    required userId,
  }) async {
    try {
      final newNote = Note(
        title: title,
        body: body,
        id: id,
        userId: userId,
      );
      LocalDatabaseHelper.instance.editNoteDB(newNote);
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }
}
