import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

import '../../../data/models/User/user_configuration.dart';
import '../../../domain/services/auth_user_service.dart';
import '../../../domain/services/user_configuration_service.dart';
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
  final User currentUser = AuthUserService.getCurrentUserFirebase();

  @override
  void initState() {
    super.initState();
    getUserConfiguration();
  }

  Future<UserConfiguration> getUserConfiguration() async {
    return await UserConfigurationService.getUserConfigurations(
        userId: currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar shows the app name and the search bar. Also handles the drawer icon.
      appBar: appBarHomePage(context: context),
      // Sidebar menu to log out and user's configurations
      drawer: FutureBuilder<UserConfiguration>(
        future: getUserConfiguration(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NavigationDrawerHomePage(userConfiguration: snapshot.data!);
          } else if (snapshot.hasError) {
            return const Text('Error loading user configuration...');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      // Stream to read the notes and a builder notes widget
      body: ReadNotesStreamConsumer(currentUser: currentUser),
      // Button to create a new note
      floatingActionButton: newNoteButton(context: context),
    );
  }
}
