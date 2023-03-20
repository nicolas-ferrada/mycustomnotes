import 'note_model_abstract.dart';

class NoteText extends NoteModel {
  String body;
  String url;
  NoteText({
    required super.id,
    required super.userId,
    required super.createdDate,
    required super.lastModificationDate,
    required super.title,
    required super.isFavorite,
    required super.color,
    required this.body,
    required this.url,
  });

  // Convert the map coming from the database to the class model
  NoteText fromMap(Map<String, dynamic> map) {
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
      'youtubeUrl': url,
    };
  }
}
