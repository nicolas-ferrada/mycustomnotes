import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/constants/routes.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/services/sqlite/note_database.dart';
import '/firebase_functions/firebase_auth.dart';
import 'dart:developer' as logs show log;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    //NoteDatabase.instance.closeDB(); // Why?
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Welcome: ${user.email}',
          style: const TextStyle(fontSize: 14),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await FirebaseFunctions.logoutFirebase();
          },
        ),
      ),
      // Read notes already created
      body: FutureBuilder(
        future: NoteDatabase.instance.readAllNotesDB(),
        builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
          if (snapshot.hasData) {
            // The list of notes it's ready
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                NoteModel notes = snapshot.data![index];
                return ListTile(
                  title: Text(notes.title),
                  subtitle: Text(notes.body),
                );
              },
            );
            // The list of notes it's NOT ready
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No notes to show'),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amberAccent,
        label: const Text('New note'),
        icon: const Icon(Icons.create),
        onPressed: () {
          Navigator.pushNamed(context, createNoteRoute);
        },
      ),
    );
  }
}
