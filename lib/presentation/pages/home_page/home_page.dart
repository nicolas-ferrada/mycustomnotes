import 'package:flutter/material.dart';

import 'home_page_widgets/home_page_app_bar_show_email_user.dart';

import 'home_page_widgets/home_page_new_note_button_widget.dart';
import 'home_page_widgets/home_page_read_notes_stream_consumer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar shows the user's mail and a button to log out
      appBar: appBarShowEmailUser(context: context),
      // Stream to read the notes and a builder notes widget
      body: readNotesStreamConsumer(),
      // Button to create a new note
      floatingActionButton: newNoteButton(context: context),
    );
  }
}
