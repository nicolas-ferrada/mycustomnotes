import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Signed in as:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              '${user.email}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            //logout
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                _logoutFirebase();
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text(
                'Sign out',
                style: TextStyle(fontSize: 24),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future _logoutFirebase() async {
  await FirebaseAuth.instance.signOut();
}
