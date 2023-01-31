import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth_functions/auth_firebase_functions.dart';
import '../auth_functions/auth_sqlite_functions.dart';

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

  // Register user firebase
  static Future<AuthUser> registerUserFirebase({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final UserCredential newUser =
        await AuthFirebaseFunctions.registerFirebaseUser(
            email, password, context);
    return AuthUser(email: email, password: password, id: newUser.user!.uid);
  }

  // Register user sqlite
  static void registerUserSqlite({
    required AuthUser user,
    required BuildContext context,
  }) async {
    await AuthSqliteFunctions.registerSqliteUser(
      user: user,
      context: context,
    );
  }
}
