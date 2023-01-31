import 'package:flutter/cupertino.dart';

import '../database/sqlite/database_helper.dart';
import '../exceptions/auth_firebase_exceptions.dart';
import '../models/user_model.dart';

class AuthSqliteFunctions {
  static Future<void> loginSqliteUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await DatabaseHelper.instance.loginUser(email, password);
    } catch (unexpectedException) {
      AuthFirebaseExceptions.showErrorDialog(context,
          "There is a unexpected error with the local login:\n$unexpectedException");
    }
  }

  // Recieves the AuthUser created by the register function of firebase
  static Future<void> registerSqliteUser({
    required AuthUser user,
    required BuildContext context,
  }) async {
    try {
      await DatabaseHelper.instance.createUser(user);
    } catch (unexpectedException) {
      AuthFirebaseExceptions.showErrorDialog(context,
          "There is a unexpected error with the local register process:\n$unexpectedException");
    }
  }
}
