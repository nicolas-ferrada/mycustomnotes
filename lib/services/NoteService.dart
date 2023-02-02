import 'package:mycustomnotes/extensions/formatted_message.dart';

import '../database/sqlite/database_helper.dart';
import '../models/note_model.dart';

class NoteService {
  // Read one note
  // note_detail_page init state

  // Read all notes
  // home page init state

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

  // Delete note in sqlite
  static Future<void> deleteNote({required int noteId}) async {
    try {
      DatabaseHelper.instance.deleteNoteDB(noteId);
    } catch (unexpectedException) {
      throw Exception("There is an unexpected error:\n$unexpectedException").getMessage;
    }
  }

  // Update note in sqlite
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
    }catch (unexpectedException){
      throw Exception("There is an unexpected error:\n$unexpectedException").getMessage;
    }
  }
}
