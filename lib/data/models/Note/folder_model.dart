// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Folder {
  static const String _idField = 'id';
  static const String _userIdField = 'userId';
  static const String _storedNoteTextIdField = 'storedNoteTextId';
  static const String _storedNoteTasksIdField = 'storedNoteTasksId';
  static const String _nameField = 'name';
  static const String _colorField = 'color';
  static const String _isFavoriteField = 'isFavorite';
  static const String _createdDateField = 'createdDate';

  final String id; // Folder's unique id
  final String userId; // User iud created by firebase auth
  final List<String>?
      storedNoteTextIdField; // Id's of the text notes stored in the folder
  final List<String>?
      storedNoteTasksIdField; // Id's of the text tasks stored in the folder
  final String name; // Folder's name
  final int color; // Folder's color
  final bool isFavorite; // Is the folder favorite? to show on top
  final Timestamp createdDate; // Used for user info and sort folders
  Folder({
    required this.id,
    required this.userId,
    this.storedNoteTextIdField,
    this.storedNoteTasksIdField,
    required this.name,
    required this.color,
    required this.isFavorite,
    required this.createdDate,
  });

  // Convert the class model to a map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _idField: id,
      _userIdField: userId,
      _storedNoteTextIdField: storedNoteTextIdField,
      _storedNoteTasksIdField: storedNoteTasksIdField,
      _nameField: name,
      _colorField: color,
      _isFavoriteField: isFavorite,
      _createdDateField: createdDate,
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map[_idField] as String,
      userId: map[_userIdField] as String,
      storedNoteTextIdField: List<String>.from(map[_storedNoteTextIdField]),
      storedNoteTasksIdField: List<String>.from(map[_storedNoteTasksIdField]),
      name: map[_nameField] as String,
      color: map[_colorField] as int,
      isFavorite: map[_isFavoriteField] as bool,
      createdDate: map[_createdDateField] as Timestamp,
    );
  }
}
