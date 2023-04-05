import 'package:flutter/material.dart';

AppBar appBarHomePage({required BuildContext context}) {
  return AppBar(
    centerTitle: true,
    title: const Text(
      'My Custom Notes',
      style: TextStyle(fontSize: 20),
    ),
    leading: Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(
            Icons.settings,
            size: 28,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: IconButton(
          icon: const Icon(
            Icons.search,
            size: 32,
          ),
          onPressed: () async {
            // Search for a note
          },
        ),
      ),
    ],
  );
}
