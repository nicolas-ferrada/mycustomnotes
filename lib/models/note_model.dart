class NoteModel {
  final int? id;
  final String title;
  final String body;

  const NoteModel({this.id, required this.title, required this.body});

  // Convert the dates to Json using maps
  Map<String, Object?>  toMap() => {
        // Arrow same as doing return {};
        'id': id,
        'title': title,
        'body': body
      };
}
