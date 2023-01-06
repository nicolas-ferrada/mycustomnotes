import 'package:mycustomnotes/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import '../../models/user_model.dart';
import 'dart:developer' as dev;

// Class for the notes in sqlite
class DatabaseHelper {
  // Singleton pattern for the database instance
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  DatabaseHelper._privateConstructor();

  // If the database is not null (it's ready created) it will return it,
  // otherwise, if is not created (meaning it's null), it will create the file and then return it.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('mycustomnotes.db');
    return _database!;
  }

  // Opening the database
  Future<Database> _initDB(String dbName) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, dbName);

    // Opens the database with the dbName and it's path.
    // If it's the first time creating it, it will calls the _createDB method to create the tables.
    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  // Executes if it's the first time opening the database.
  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE note(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      body TEXT,
      user_id TEXT NOT NULL,
      FOREIGN KEY(user_id) REFERENCES user(id)
    )
''');

    await db.execute('''
    CREATE TABLE user(
      id TEXT PRIMARY KEY,
      email TEXT,
      password TEXT
    )
''');
  }

  // Closes the database
  Future closeDB() async {
    final db = await instance.database;
    db.close();
  }

  // Notes CRUD OPERATIONS in sqlite

  // Create a new note
  Future<void> createNoteDB(Note note) async {
    // Reference to the db singleton instance
    final Database db = await instance.database;
    await db.insert('note', note.toMap());
  }

  // Read all notes but ONLY those who match with user's id.
  Future<List<Note>> readAllNotesDB(String userId) async {
    final db = await instance.database;
    //final results = await db.query('note');
    final notesFromUser = await db.rawQuery('''
        SELECT id, title, body FROM note WHERE user_id = "$userId";
 ''');
    return notesFromUser.map((map) => Note.fromMap(map)).toList();
  }

  // Read one note
  Future<Note> readOneNoteDB(int noteId) async {
    final db = await instance.database;
    final mapResult =
        await db.query('note', where: 'id = ?', whereArgs: [noteId]);
    if (mapResult.isNotEmpty) {
      return Note.fromMap(mapResult.first);
    } else {
      throw Exception('ID $noteId not found');
    }
  }

  // Delete a note
  Future<void> deleteNoteDB(int noteId) async {
    final db = await instance.database;
    await db.delete('note', where: 'id = ?', whereArgs: [noteId]);
  }

  // Edit a note
  Future<void> editNoteDB(Note note) async {
    final db = await instance.database;
    await db
        .update('note', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  // User CRUD OPERATIONS in sqlite

  // Create a new user
  Future<void> createUser(User user) async {
    final db = await instance.database;
    await db.insert('user', user.toMap());
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await instance.database;
    final login = await db.rawQuery('''
      SELECT * FROM user WHERE email = "$email" AND password = "$password";
 ''');

    if (login.isNotEmpty) {
      dev.log('logged in');
      return User.fromMap(login.first);
    } else {
      dev.log('NOT logged in');
      return null;
    }
  }
}
