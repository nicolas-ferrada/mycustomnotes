// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'note_model_abstract.dart';

class NoteText extends NoteModel {
  String body;
  String? url;
  NoteText({
    required super.id,
    required super.userId,
    required super.createdDate,
    required super.lastModificationDate,
    required super.title,
    required super.isFavorite,
    required super.color,
    required this.body,
    this.url,
  });

  // Convert the map coming from the database to the class model
  static NoteText fromMap(Map<String, dynamic> map) {
    return NoteText(
      id: map['id'],
      userId: map['userId'],
      createdDate: map['createdDate'],
      lastModificationDate: map['lastModificationDate'],
      title: map['title'],
      isFavorite: map['isFavorite'],
      color: map['color'],
      body: map['body'],
      url: map['url'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'createdDate': createdDate,
      'lastModificationDate': lastModificationDate,
      'title': title,
      'isFavorite': isFavorite,
      'color': color,
      'body': body,
      'url': url,
    };
  }

  NoteText copyWith({
    String? body,
    String? url,
  }) {
    return NoteText(
      id: super.id,
      userId: super.userId,
      title: super.title,
      color: super.color,
      createdDate: super.createdDate,
      isFavorite: super.isFavorite,
      lastModificationDate: super.lastModificationDate,
      body: body ?? this.body,
      url: url ?? this.url,
    );
  }
}
