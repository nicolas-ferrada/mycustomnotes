class Note {
  final String id; // Document id created by firestore
  final String title; // Title created by user
  final String body; // Body created by user
  final String userId; // User iud created by firebase auth
  // date

  const Note(
      {required this.id, required this.title, required this.body, required this.userId});

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
