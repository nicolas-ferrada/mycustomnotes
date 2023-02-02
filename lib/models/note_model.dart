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
}
