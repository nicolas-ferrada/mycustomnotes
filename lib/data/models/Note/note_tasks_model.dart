// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'note_model_abstract.dart';

class NoteTasks extends NoteModel {
  List<Map<String, dynamic>> tasks;
  NoteTasks({
    required super.id,
    required super.userId,
    required super.createdDate,
    required super.lastModificationDate,
    required super.title,
    required super.isFavorite,
    required super.color,
    required List<Map<String, dynamic>>? tasks,
    // Transform the tasks field from the List<dynamic> (firestore returns that) to List<String>
  }) : tasks = tasks
                ?.map((task) => {
                      'taskName': task['taskName'] ?? '',
                      'isTaskCompleted': task['isTaskCompleted'] ?? false,
                    })
                .toList() ??
            [];

  // Convert the map coming from the database to the class model
  static NoteTasks fromMap(Map<String, dynamic> map) {
    return NoteTasks(
      id: map['id'],
      userId: map['userId'],
      createdDate: map['createdDate'],
      lastModificationDate: map['lastModificationDate'],
      title: map['title'],
      isFavorite: map['isFavorite'],
      color: map['color'],
      tasks: (map['tasks'] as List<dynamic>?)
          ?.map((task) => {
                'taskName': task['taskName'] ?? '',
                'isTaskCompleted': task['isTaskCompleted'] ?? false,
              })
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'createdDate': createdDate,
      'lastModificationDate': lastModificationDate,
      'title': title,
      'isFavorite': isFavorite,
      'color': color,
      'tasks': tasks,
    };
  }

  NoteTasks copyWith({
    List<Map<String, dynamic>>? tasks,
  }) {
    return NoteTasks(
      id: super.id,
      userId: super.userId,
      color: super.color,
      createdDate: super.createdDate,
      isFavorite: super.isFavorite,
      lastModificationDate: super.lastModificationDate,
      title: super.title,
      tasks: this.tasks,
    );
  }
}
