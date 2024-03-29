import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/models/Note/note_text_model.dart';
import '../../l10n/l10n_export.dart';
import '../../utils/extensions/formatted_message.dart';
import '../../utils/internet/check_internet_connection.dart';

class NoteTextService {
  // Read all text notes from one user in firebase
  static Stream<List<NoteText>> readAllNotesText({
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
            .collection('noteText')
            .where('userId', isEqualTo: userId)
            .get(const GetOptions(source: Source.serverAndCache));
      } else {
        documents = await db
            .collection('noteText')
            .where('userId', isEqualTo: userId)
            .get(const GetOptions(source: Source.cache));
      }

      List<NoteText> textNotes = [];
      for (var docSnapshots in documents.docs) {
        final data = NoteText.fromMap(docSnapshots.data());
        textNotes.add(data);
      }
      yield textNotes;
    } catch (e) {
      if (!context.mounted) return;
      throw Exception(
          AppLocalizations.of(context)!.notesService_exception_gettingNotes);
    }
  }

  // Create a note in firebase
  static Future<void> createNoteText({
    required BuildContext context,
    required String title,
    required String body,
    required String userId,
    required bool isFavorite,
    required int color,
    String? url,
  }) async {
    try {
      // References to the firestore colletion.
      final noteCollection = FirebaseFirestore.instance.collection('noteText');

      // Generate the document id
      final documentReference = noteCollection.doc();
      // Applies the created id documents of firestore to the noteId
      final noteId = documentReference.id;

      final noteText = NoteText(
          id: noteId,
          title: title,
          body: body,
          userId: userId,
          lastModificationDate: Timestamp.now(),
          createdDate: Timestamp.now(),
          isFavorite: isFavorite,
          color: color,
          url: url);

      // Transform that note object into a map to store it.
      final mapNote = noteText.toMap();

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
  static Future<void> editNoteText({
    required NoteText note,
    required BuildContext context,
  }) async {
    try {
      // Create the new note to replace the other
      final finalNoteText = NoteText(
        id: note.id,
        title: note.title,
        body: note.body,
        userId: note.userId,
        lastModificationDate: Timestamp.now(),
        createdDate: note.createdDate,
        isFavorite: note.isFavorite,
        color: note.color,
        url: note.url,
      );
      final db = FirebaseFirestore.instance;

      final docNote = db.collection('noteText').doc(note.id);

      final mapNote = finalNoteText.toMap();

      await docNote.set(mapNote);
    } catch (unexpectedException) {
      if (!context.mounted) return;
      throw Exception(
              AppLocalizations.of(context)!.notesService_exception_editingNote)
          .removeExceptionWord;
    }
  }

  // Delete a note in firebase
  static Future<void> deleteNoteText({
    required noteId,
    required BuildContext context,
  }) async {
    try {
      final db = FirebaseFirestore.instance;

      final docNote = db.collection('noteText').doc(noteId);

      await docNote.delete();
    } catch (_) {
      if (!context.mounted) return;
      throw Exception(
              AppLocalizations.of(context)!.notesService_exception_deletingNote)
          .removeExceptionWord;
    }
  }
}
