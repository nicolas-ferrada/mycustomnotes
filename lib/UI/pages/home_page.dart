import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/create_note_page.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/notifiers/note_model_notifier.dart';
import 'package:mycustomnotes/services/sqlite/note_database.dart';
import 'package:provider/provider.dart';
import '/firebase_functions/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    Provider.of<NoteModelNotifier>(context, listen: false).refreshNote();
    super.initState();
  }

  @override
  void dispose() {
    NoteDatabase.instance.closeDB(); // Why?
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
      // Body to show the notes
      body: Consumer<NoteModelNotifier>(
        builder: (context, value, child) {
          return FutureBuilder(
            future: NoteDatabase.instance.readAllNotesDB(),
            builder: (context, AsyncSnapshot<List<NoteModel>> snapshot) {
              if (snapshot.hasData) {
                List<NoteModel> thereAreNotes = snapshot.data!;
                if (thereAreNotes.isNotEmpty) {
                  // Show the available notes if there is any note
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      NoteModel notes = snapshot.data![index];
                      return ListTile(
                        title:
                            Center(child: Text(notes.title)),
                        subtitle: Center(child: Text(notes.body)),
                      );
                    },
                  );
                } else {
                  // There are no notes to show
                  return const Center(
                      child: Text("You have no notes created."));
                }
              } else {
                // The data it's still loading
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
      // Button create a new note page
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amberAccent,
        label: const Text('New note'),
        icon: const Icon(Icons.create),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => const CreateNote(),
          ))
              .then((_) {
                // Updates the notes in the UI
            Provider.of<NoteModelNotifier>(context, listen: false)
                .refreshNote();
          });
        },
      ),
    );
  }
}
