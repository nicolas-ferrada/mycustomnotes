// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id; // Document id created by firestore
  final String userId; // User iud created by firebase auth
  final Timestamp createdDate; // Date of creation, displayed on info
  Timestamp lastModificationDate; // Displayed on note card
  String title; // Title of note created by user
  String body; // Body of note created by user
  bool isFavorite; // Star icon displayed on note card and affects display order
  int color; // Displayed as background of note card
  String? url; // Used to store a url

  Note({
    required this.id,
    required this.userId,
    required this.createdDate,
    required this.lastModificationDate,
    required this.title,
    required this.body,
    required this.isFavorite,
    required this.color,
    this.url,
  });

  // Convert the class model to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'createdDate': createdDate,
      'lastModificationDate': lastModificationDate,
      'title': title,
      'body': body,
      'isFavorite': isFavorite,
      'color': color,
      'youtubeUrl': url,
    };
  }

  // Convert the map coming from the database to the class model
  static Note fromMap(Map<String, dynamic> map) => Note(
        id: map['id'],
        userId: map['userId'],
        createdDate: map['createdDate'],
        lastModificationDate: map['lastModificationDate'],
        title: map['title'],
        body: map['body'],
        isFavorite: map['isFavorite'],
        color: map['color'],
        url: map['url'],
      );

  Note copyWith({
    String? id,
    String? userId,
    Timestamp? createdDate,
    Timestamp? lastModificationDate,
    String? title,
    String? body,
    bool? isFavorite,
    int? color,
    String? url,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdDate: createdDate ?? this.createdDate,
      lastModificationDate: lastModificationDate ?? this.lastModificationDate,
      title: title ?? this.title,
      body: body ?? this.body,
      isFavorite: isFavorite ?? this.isFavorite,
      color: color ?? this.color,
      url: url ?? this.url,
    );
  }
}
