enum SelectLanguage {
  english('EN', 'English', 1),
  spanish('ES', 'Spanish', 2);

  const SelectLanguage(this.lenguageId, this.languageName, this.languageIndex);
  final String lenguageId;
  final String languageName;
  final int languageIndex;
}
