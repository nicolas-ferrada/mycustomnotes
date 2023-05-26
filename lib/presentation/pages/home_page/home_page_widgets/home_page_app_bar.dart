import 'package:flutter/material.dart';

class AppBarHomePage extends StatefulWidget {
  const AppBarHomePage({super.key});

  @override
  State<AppBarHomePage> createState() => _AppBarHomePageState();
}

class _AppBarHomePageState extends State<AppBarHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      centerTitle: true,
      title: const Text(
        'My Custom Notes',
        style: TextStyle(fontSize: 20),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.settings,
          size: 28,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
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
    ));
  }
}
