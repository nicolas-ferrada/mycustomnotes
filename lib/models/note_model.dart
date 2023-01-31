import '../database/sqlite/database_helper.dart';

class Note {
  final int? id;
  final String title;
  final String body;
  final String userId;

  const Note(
      {this.id, required this.title, required this.body, required this.userId});

  // Convert the class model to a map
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'body': body, 'userId': userId};
  }

  // Convert the map coming from the database to the class model
  static Note fromMap(Map<String, dynamic> map) => Note(
        id: map['id'],
        title: map['title'],
        body: map['body'],
        userId: map['userId'],
      );

  // Read one note
  // note_detail_page init state

  // Read all notes
  // home page init state

  // Create note
  static void createNoteDB({
    required String title,
    required String body,
    required String userId,
  }) {
    final note = Note(title: title, body: body, userId: userId);
    DatabaseHelper.instance.createNoteDB(note);
  }

  // Delete note
  static void deleteNote({required int noteId}) {
    DatabaseHelper.instance.deleteNoteDB(noteId);
  }

  // Update note
  static void editNote({
    required String title,
    required String body,
    required int id,
    required userId,
  }) {
    final newNote = Note(
      title: title,
      body: body,
      id: id,
      userId: userId,
    );
    DatabaseHelper.instance.editNoteDB(newNote);
  }
}
