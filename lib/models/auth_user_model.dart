class AuthUser {
  String id;
  final String email;
  final String password;

  AuthUser({required this.id, required this.email, required this.password});

  // Convert the class model to a map
  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'password': password};
  }

  // Convert the map coming from the database to the class model
  static AuthUser fromMap(Map<String, dynamic> map) => AuthUser(
        id: map['id'],
        email: map['email'],
        password: map['password'],
      );
}
