import 'package:flutter/material.dart';

import 'home_page_widgets/home_page_app_bar.dart';
import 'home_page_widgets/home_page_navigation_drawer.dart';
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
      // AppBar shows the app name and the search bar. Also handles the drawer icon.
      appBar: appBarHomePage(context: context),
      // Sidebar menu to log out and user's configurations
      drawer: const NavigationDrawerHomePage(),
      // Stream to read the notes and a builder notes widget
      body: ReadNotesStreamConsumer(),
      // Button to create a new note
      floatingActionButton: newNoteButton(context: context),
    );
  }
}
