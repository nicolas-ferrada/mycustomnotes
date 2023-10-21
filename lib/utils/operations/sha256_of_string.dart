import 'dart:convert';
import 'package:crypto/crypto.dart';

class Sha256OfString {
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
