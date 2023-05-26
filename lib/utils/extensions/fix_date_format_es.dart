extension StringExtension on String {
  // If the string have a dot, removes it
  // If the first letter of a word is lowercase, make it uppercase.
  String fixSpanishDate() {
    String modifiedString = this;

    if (modifiedString.contains('.')) {
      modifiedString = modifiedString.replaceAll('.', '');
    }

    List<String> words = modifiedString.split(' ');
    List<String> capitalizedWords = [];

    for (String word in words) {
      if (word.isNotEmpty && word[0].toLowerCase() == word[0]) {
        word = word.replaceRange(0, 1, word[0].toUpperCase());
      }
      capitalizedWords.add(word);
    }

    return capitalizedWords.join(' ');
  }
}
