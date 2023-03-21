import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUtils {
  static Future<void> renameCollection(
    String currentName,
    String newName,
  ) async {
    try {
      final db = FirebaseFirestore.instance;

      // 1. Create a new collection with the desired name.
      await db.collection(newName).doc('dummy').set({});

      // 2. Read all the documents from the old collection.
      final oldCollectionRef = db.collection(currentName);
      final oldCollectionDocs = await oldCollectionRef.get();

      // 3. Write the documents to the new collection.
      final newCollectionRef = db.collection(newName);
      final batch = db.batch();
      for (final doc in oldCollectionDocs.docs) {
        batch.set(newCollectionRef.doc(doc.id), doc.data());
      }
      await batch.commit();

      // 4. Delete the old collection.
      for (final doc in oldCollectionDocs.docs) {
        await oldCollectionRef.doc(doc.id).delete();
      }
      await db.collection(currentName).doc('dummy').delete();
    } catch (e) {
      throw Exception('Error renaming collection: $e');
    }
  }
}
