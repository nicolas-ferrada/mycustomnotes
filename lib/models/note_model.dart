import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id; // Document id created by firestore
  final String title; // Title created by user
  final String body; // Body created by user
  final String userId; // User iud created by firebase auth
  final Timestamp
       lastModificationDate; // Displayed outside the note, changes on edit
  final Timestamp?
      createdDate; // Date of creation (can't be modified) displayed on details

  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.lastModificationDate,
    required this.createdDate,
  });

  // Convert the class model to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
      'lastModificationDate': lastModificationDate,
      'createdDate': createdDate,
    };
  }

  // Convert the map coming from the database to the class model
  static Note fromMap(Map<String, dynamic> map) => Note(
        id: map['id'],
        title: map['title'],
        body: map['body'],
        userId: map['userId'],
        lastModificationDate: map['lastModificationDate'],
        createdDate: map['createdDate'],
      );
}
