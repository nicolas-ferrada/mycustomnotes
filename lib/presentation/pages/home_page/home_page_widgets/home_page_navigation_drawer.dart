import 'package:flutter/material.dart';

import '../../../../utils/dialogs/confirmation_dialog.dart';

class NavigationDrawerHomePage extends StatelessWidget {
  const NavigationDrawerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      width: 250,
      child: Column(
        children: [
          buildHeader(context),
          buildMenuItems(context),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        runSpacing: 20,
        children: [
          // Title
          const ListTile(
            title: Text(
              'Settings menu',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ), // Change language
          const Divider(thickness: 1),
          changeLanguage(),
          const Divider(thickness: 1),
          dateAndHourStyle(),
          const Divider(thickness: 1),
          notesStyleVisualization(),
          const Divider(thickness: 1),
          logout(context: context),
          const Divider(thickness: 1),
        ],
      ),
    );
  }

  Widget changeLanguage() {
    return const ListTile(
      leading: Icon(Icons.language, size: 28),
      title: Text(
        'Language',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget dateAndHourStyle() {
    return const ListTile(
      leading: Icon(Icons.date_range, size: 28),
      title: Text(
        'Date and time format',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget notesStyleVisualization() {
    return const ListTile(
      leading: Icon(Icons.grid_view, size: 28),
      title: Text(
        'Notes view',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget logout({required BuildContext context}) {
    return ListTile(
      onTap: () {
        ConfirmationDialog.logOutDialog(context);
      },
      leading: Transform.scale(
        scaleX: -1,
        child: const Icon(
          Icons.logout,
          size: 28,
        ),
      ),
      title: const Text(
        'Log out',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
