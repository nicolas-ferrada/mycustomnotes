class AuthUser {
  final String id;
  final String email;

  AuthUser({required this.id, required this.email});

  // Convert the class model to a map
  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email};
  }

  // Convert the map coming from the database to the class model
  static AuthUser fromMap(Map<String, dynamic> map) => AuthUser(
        id: map['id'],
        email: map['email'],
      );
}
