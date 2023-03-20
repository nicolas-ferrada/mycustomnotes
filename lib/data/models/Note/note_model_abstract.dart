import 'package:cloud_firestore/cloud_firestore.dart';

abstract class NoteModel {
  final String id; // Document id created by firestore
  final String userId; // User iud created by firebase auth
  final Timestamp createdDate; // Date of creation, displayed on info
  Timestamp lastModificationDate; // Displayed on note card
  String title; // Title of note created by user
  bool isFavorite; // Star icon displayed on note card and affects display order
  int color; // Displayed as background of note card

  NoteModel({
    required this.id,
    required this.userId,
    required this.createdDate,
    required this.lastModificationDate,
    required this.title,
    required this.isFavorite,
    required this.color,
  });

  // Convert the class model to a map
  Map<String, dynamic> toMap();

}
