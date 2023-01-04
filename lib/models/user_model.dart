class User {
  final int? id;
  final String email;

  const User({this.id, required this.email});

  // Convert the class model to a map
  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email};
  }

  // Convert the map coming from the database to the class model
  static User fromMap(Map<String, dynamic> map) => User(
        id: map['id'],
        email: map['email'],
      );
}
