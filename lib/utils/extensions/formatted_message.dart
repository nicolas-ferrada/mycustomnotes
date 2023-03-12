// Removes the 'Exception: ' word on the user's alert dialog messages
extension FormattedMessage on Exception {
  String get getMessage {
    if (toString().startsWith("Exception: ")) {
      return toString().substring(11);
    } else {
      return toString();
    }
  }
}
