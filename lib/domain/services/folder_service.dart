import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';

import '../../data/models/Note/folder_model.dart';
import '../../utils/internet/check_internet_connection.dart';

class FolderService {
  static Stream<List<Folder>> readAllFolders({
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
            .collection('folder')
            .where('userId', isEqualTo: userId)
            .get(const GetOptions(source: Source.serverAndCache));
      } else {
        documents = await db
            .collection('folder')
            .where('userId', isEqualTo: userId)
            .get(const GetOptions(source: Source.cache));
      }

      List<Folder> folders = [];
      for (var docSnapshots in documents.docs) {
        final data = Folder.fromMap(docSnapshots.data());
        folders.add(data);
      }
      yield folders;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> createFolder({
    required BuildContext context,
    required Folder folder,
  }) async {
    try {
      final noteCollection = FirebaseFirestore.instance.collection('folder');
      final documentReference = noteCollection.doc();
      final folderId = documentReference.id;

      final Folder finalFolder = Folder(
        id: folderId,
        userId: folder.userId,
        storedNoteTasksIdField: folder.storedNoteTasksIdField,
        storedNoteTextIdField: folder.storedNoteTextIdField,
        color: folder.color,
        createdDate: folder.createdDate,
        isFavorite: folder.isFavorite,
        name: folder.name,
      );

      final mapFolder = finalFolder.toMap();

      await documentReference.set(mapFolder);
    } catch (unexpectedException) {
      throw Exception('').removeExceptionWord;
    }
  }

  // Update a note in firebase
  static Future<void> editFolder({
    required Folder folder,
    required BuildContext context,
  }) async {
    try {
      final finalFolder = Folder(
        id: folder.id,
        name: folder.name,
        userId: folder.userId,
        createdDate: folder.createdDate,
        isFavorite: folder.isFavorite,
        color: folder.color,
        storedNoteTasksIdField: folder.storedNoteTasksIdField,
        storedNoteTextIdField: folder.storedNoteTextIdField,
      );

      final db = FirebaseFirestore.instance;

      final docFolder = db.collection('folder').doc(folder.id);

      final mapFolder = finalFolder.toMap();

      await docFolder.set(mapFolder);
    } catch (unexpectedException) {
      throw Exception('').removeExceptionWord;
    }
  }

  // Delete a note in firebase
  static Future<void> deleteFolder({
    required String folderId,
    required BuildContext context,
  }) async {
    try {
      final db = FirebaseFirestore.instance;

      final docFolder = db.collection('folder').doc(folderId);

      await docFolder.delete();
    } catch (_) {
      throw Exception('').removeExceptionWord;
    }
  }
}
