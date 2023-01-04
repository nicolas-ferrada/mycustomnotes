import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/UI/pages/create_note_page.dart';
import 'package:mycustomnotes/UI/pages/note_detail_page.dart';
import 'package:mycustomnotes/models/note_model.dart';
import 'package:mycustomnotes/notifiers/note_model_notifier.dart';
import 'package:mycustomnotes/database/sqlite/database_helper.dart';
import 'package:mycustomnotes/widgets/notes_widget.dart';
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
    DatabaseHelper.instance.closeDB();
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
            future: DatabaseHelper.instance.readAllNotesDB(),
            builder: (context, AsyncSnapshot<List<Note>> snapshot) {
              if (snapshot.hasData) {
                List<Note> thereAreNotes = snapshot.data!;
                if (thereAreNotes.isNotEmpty) {
                  // Show the available notes if there is any note
                  return GridView.custom(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      childCount: thereAreNotes.length,
                      ((context, index) {
                        Note note = snapshot.data![index];
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NoteDetail(noteId: note.id!)),
                              )
                                  .then(
                                (_) {
                                  Provider.of<NoteModelNotifier>(context,
                                          listen: false)
                                      .refreshNote();
                                },
                              );
                            },
                            child: NotesWidget(note: note, index: index));
                      }),
                    ),
                  );
                } else {
                  // There are no notes to show
                  return const Center(
                      child: Text("You have no notes created."));
                }
              } else {
                // The data it's still loading from database
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
              .push(
            MaterialPageRoute(
              builder: (context) => const CreateNote(),
            ),
          )
              .then(
            (_) {
              Provider.of<NoteModelNotifier>(context, listen: false)
                  .refreshNote();
            },
          );
        },
      ),
    );
  }
}

//NoteModel notes = snapshot.data![index];
