class UserConfiguration {
  final String userId; // user's id owns this config
  final String dateTimeFormat; // app on load date and time format
  final int notesView; // notes grid view. 1x1, 2x2, 3x3.

  const UserConfiguration({
    required this.userId,
    required this.dateTimeFormat,
    required this.notesView,
  });

  // Convert the class model to a map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'dateTimeFormat': dateTimeFormat,
      'notesView': notesView,
    };
  }

  factory UserConfiguration.fromMap(Map<String, dynamic> map) {
    return UserConfiguration(
      userId: map['userId'] as String,
      dateTimeFormat: map['dateTimeFormat'] as String,
      notesView: map['notesView'] as int,
    );
  }
}
