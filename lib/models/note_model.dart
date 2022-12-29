class NoteModel {
  final int? id;
  final String title;
  final String body;

  const NoteModel({this.id, required this.title, required this.body});

  // Convert the class model to a map
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'body': body};
  }

  // Convert the map coming from the database to the class model
  static NoteModel fromMap(Map<String, dynamic> map) => NoteModel(
        id: map['id'],
        title: map['title'],
        body: map['body'],
      );
}
