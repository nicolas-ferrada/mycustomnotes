import 'package:mycustomnotes/extensions/formatted_message.dart';
import '../database/sqlite/database_helper.dart';
import '../models/note_model.dart';

class NoteService {
  // Read one note from Firebase

  // Read one note from sqlite and return it
  static Future<Note> readOneNoteDB({
    required int noteId,
  }) async {
    try {
      final Note fromDBNote =
          await DatabaseHelper.instance.readOneNoteDB(noteId);
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
          await DatabaseHelper.instance.readAllNotesDB(userId);
      return allNotesFromDB;
    } catch (unexpectedException) {
      throw Exception("There is a unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Create a note in firebase

  // Create note in sqlite
  static Future<void> createNoteDB({
    required String title,
    required String body,
    required String userId,
  }) async {
    try {
      final note = Note(title: title, body: body, userId: userId);
      await DatabaseHelper.instance.createNoteDB(note);
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }

  // Delete a note in firebase

  // Delete a note in sqlite
  static Future<void> deleteNote({required int noteId}) async {
    try {
      DatabaseHelper.instance.deleteNoteDB(noteId);
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
      DatabaseHelper.instance.editNoteDB(newNote);
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException")
          .getMessage;
    }
  }
}
