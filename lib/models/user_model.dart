class User {
  String id;
  final String email;
  final String password;

  User({required this.id, required this.email, required this.password});

  // Convert the class model to a map
  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'password': password};
  }

  // Convert the map coming from the database to the class model
  static User fromMap(Map<String, dynamic> map) => User(
        id: map['id'],
        email: map['email'],
        password: map['password'],
      );
}
