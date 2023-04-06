class UserConfiguration {
  final String userId; // user's id owns this config
  final String language; // app on load language
  final String dateTimeFormat; // app on load date and time format
  final String notesView; // notes grid view. 1x1, 2x2, 3x3.

  const UserConfiguration({
    required this.userId,
    required this.language,
    required this.dateTimeFormat,
    required this.notesView,
  });

  // Convert the class model to a map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'language': language,
      'dateTimeFormat': dateTimeFormat,
      'notesView': notesView,
    };
  }

  factory UserConfiguration.fromMap(Map<String, dynamic> map) {
    return UserConfiguration(
      userId: map['userId'] as String,
      language: map['language'] as String,
      dateTimeFormat: map['dateTimeFormat'] as String,
      notesView: map['notesView'] as String,
    );
  }
}
