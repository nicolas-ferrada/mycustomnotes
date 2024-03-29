import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../l10n/l10n_export.dart';

import '../../data/models/Note/note_tasks_model.dart';
import '../../utils/extensions/formatted_message.dart';
import '../../utils/internet/check_internet_connection.dart';

class NoteTasksService {
  // Read all tasks notes from one user in firebase
  static Stream<List<NoteTasks>> readAllNotesTasks({
    required String userId,
    required BuildContext context,
  }) async* {
    try {
      final db = FirebaseFirestore.instance;

      bool isDeviceConnected =
          await CheckInternetConnection.checkInternetConnection();

      QuerySnapshot<Map<String, dynamic>> documents;

      if (isDeviceConnected) {
        documents = await db
            .collection('noteTasks')
            .where('userId', isEqualTo: userId)
            .get(const GetOptions(source: Source.serverAndCache));
      } else {
        documents = await db
            .collection('noteTasks')
            .where('userId', isEqualTo: userId)
            .get(const GetOptions(source: Source.cache));
      }

      List<NoteTasks> noteTasks = [];
      for (var docSnapshots in documents.docs) {
        final data = NoteTasks.fromMap(docSnapshots.data());
        noteTasks.add(data);
      }
      yield noteTasks;
    } catch (e) {
      if (!context.mounted) return;
      throw Exception(
          AppLocalizations.of(context)!.notesService_exception_gettingNotes);
    }
  }

  // Create a note in firebase
  static Future<void> createNoteTasks({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> tasks,
    required String userId,
    required bool isFavorite,
    required int color,
  }) async {
    try {
      // References to the firestore colletion.
      final noteCollection = FirebaseFirestore.instance.collection('noteTasks');

      // Generate the document id
      final documentReference = noteCollection.doc();

      // Applies the created id documents of firestore to the noteId
      final noteId = documentReference.id;

      final noteTasks = NoteTasks(
        id: noteId,
        title: title,
        tasks: tasks,
        userId: userId,
        lastModificationDate: Timestamp.now(),
        createdDate: Timestamp.now(),
        isFavorite: isFavorite,
        color: color,
      );

      // Transform that note object into a map to store it.
      final mapNote = noteTasks.toMap();

      // Store the note object in firestore
      await documentReference.set(mapNote);
    } catch (unexpectedException) {
      if (!context.mounted) return;
      throw Exception(
              AppLocalizations.of(context)!.notesService_exception_creatingNote)
          .removeExceptionWord;
    }
  }

  // Update a note in firebase
  static Future<void> editNoteTasks({
    required NoteTasks note,
    required BuildContext context,
  }) async {
    try {
      // Create the new note to replace the other
      final finalNoteTasks = NoteTasks(
        id: note.id,
        title: note.title,
        tasks: note.tasks,
        userId: note.userId,
        lastModificationDate: Timestamp.now(),
        createdDate: note.createdDate,
        isFavorite: note.isFavorite,
        color: note.color,
      );
      final db = FirebaseFirestore.instance;

      final docNote = db.collection('noteTasks').doc(note.id);

      final mapNote = finalNoteTasks.toMap();

      await docNote.set(mapNote);
    } catch (unexpectedException) {
      if (!context.mounted) return;
      throw Exception(
              AppLocalizations.of(context)!.notesService_exception_editingNote)
          .removeExceptionWord;
    }
  }

  // Delete a note in firebase
  static Future<void> deleteNoteTasks({
    required String noteId,
    required BuildContext context,
  }) async {
    try {
      final db = FirebaseFirestore.instance;

      final docNote = db.collection('noteTasks').doc(noteId);

      await docNote.delete();
    } catch (_) {
      if (!context.mounted) return;
      throw Exception(
              AppLocalizations.of(context)!.notesService_exception_deletingNote)
          .removeExceptionWord;
    }
  }
}
