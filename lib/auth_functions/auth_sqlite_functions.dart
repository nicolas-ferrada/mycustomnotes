import '../database/sqlite/database_helper.dart';
import '../models/user_model.dart';
import 'dart:developer' as devtools;

class AuthSqliteFunctions{

  static Future<void> loginSqliteUser(String email, String password) async {
    try{
      await DatabaseHelper.instance.loginUser(email, password);
    }
    catch (unexpectedException){
      devtools.log('Unexpected error, $unexpectedException');
    }
  }


  static Future<void> registerSqliteUser(String email, String password) async {
    try{
        final user = User(
         email: email.trim(),
         password: password.trim());
         await DatabaseHelper.instance.createUser(user);
    }
    catch (unexpectedException){
      devtools.log('Unexpected error, $unexpectedException');
    }


  }
}