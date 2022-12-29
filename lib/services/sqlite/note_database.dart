import 'package:mycustomnotes/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as logs show log;

// Class for the notes in sqlite
class NoteDatabase {
  // Singleton pattern for the database instance
  static final NoteDatabase instance = NoteDatabase._privateConstructor();

  static Database? _database;

  NoteDatabase._privateConstructor();

  // If the database is not null (it's ready created) it will return it,
  // otherwise, if is not created (meaning it's null), it will create the file and then return it.
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('note.db');
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
      body TEXT
    )
''');
  }

  // CRUD OPERATIONS in sqlite

  // Create a new note
  Future<void> createNoteDB(NoteModel note) async {
    // Reference to the db singleton instance
    final Database db = await instance.database;
    await db.insert('note', note.toMap());
  }

  // Read all notes
  Future<List<NoteModel>> readAllNotesDB() async {
    final db = await instance.database;
    final results = await db.query('note');
    return results.map((map) => NoteModel.fromMap(map)).toList();
  }

  // Closes the database
  Future closeDB() async {
    final db = await instance.database;
    db.close();
  }
}
