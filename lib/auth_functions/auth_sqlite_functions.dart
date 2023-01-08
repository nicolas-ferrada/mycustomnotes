import 'package:flutter/cupertino.dart';

import '../database/sqlite/database_helper.dart';
import '../exceptions/auth_firebase_exceptions.dart';
import '../models/user_model.dart';

class AuthSqliteFunctions{

  static Future<void> loginSqliteUser(String email, String password, BuildContext context) async {
    try{
      await DatabaseHelper.instance.loginUser(email, password);
    }
    catch (unexpectedException){
      AuthFirebaseExceptions.showErrorDialog(
          context, "There is a unexpected error with the local login:\n$unexpectedException");
    }
  }


  static Future<void> registerSqliteUser({required String email, required String password, required String uid, required BuildContext context}) async {
    try{
        final user = User(
         id: uid,
         email: email.trim(),
         password: password.trim());
         await DatabaseHelper.instance.createUser(user);
    }
    catch (unexpectedException){
      AuthFirebaseExceptions.showErrorDialog(
          context, "There is a unexpected error with the local register process:\n$unexpectedException");
    }


  }
}