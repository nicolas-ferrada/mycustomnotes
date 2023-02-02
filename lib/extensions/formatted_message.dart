// Removes the 'Exception: ' word on the user's alert dialog messages
extension FormattedMessage on Exception {
  String get getMessage {
    if (this.toString().startsWith("Exception: ")) {
      return this.toString().substring(11);
    } else {
      return this.toString();
    }
  }
}
