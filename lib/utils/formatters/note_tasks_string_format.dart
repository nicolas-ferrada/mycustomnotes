import 'package:mycustomnotes/data/models/Note/note_tasks_model.dart';

class NoteTasksStringFormat {
  static String getPendingTasksFormat({
    required NoteTasks noteTasks,
  }) {
    String pendingTasksFormat = '';
    String task = '';
    // Since tasks are shown reversed, so to make them order like in the app
    Iterable<Map<String, dynamic>> reversedTasks = noteTasks.tasks.reversed;
    for (int i = 0; i < reversedTasks.length; i++) {
      if (reversedTasks.elementAt(i)['isTaskCompleted'] == false) {
        task = reversedTasks.elementAt(i)['taskName'];
        pendingTasksFormat += '- $task\n';
      }
    }
    return pendingTasksFormat;
  }

  static String getFinishedTasksFormat({
    required NoteTasks noteTasks,
  }) {
    String finishedTasksFormat = '';
    String task = '';
    Iterable<Map<String, dynamic>> reversedTasks = noteTasks.tasks.reversed;
    for (int i = 0; i < reversedTasks.length; i++) {
      if (reversedTasks.elementAt(i)['isTaskCompleted'] == true) {
        task = reversedTasks.elementAt(i)['taskName'];

        finishedTasksFormat += '- $task\n';
      }
    }
    return finishedTasksFormat;
  }
}
