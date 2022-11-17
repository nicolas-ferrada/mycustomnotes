import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Custom Notes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Login button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 30),
                backgroundColor: const Color.fromARGB(255, 221, 86, 76),
                minimumSize: const Size(250, 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
              ),
              onPressed: () {},
              child: const Text('Login'),
            ),
            const Text(
              'Press to log in to your account',
              style: TextStyle(color: Color.fromARGB(255, 199, 199, 199)),
            ),
            const Divider(height: 80),
            //Register button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 30),
                backgroundColor: const Color.fromARGB(255, 221, 86, 76),
                minimumSize: const Size(250, 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
              ),
              onPressed: () {},
              child: const Text('Register'),
            ),
            const Text(
              'Press to create an account',
              style: TextStyle(
                color: Color.fromARGB(255, 199, 199, 199),
              ),
            ),
            //Exit button
            const Padding(padding: EdgeInsets.all(20)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(100, 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(10)),
              onPressed: () {},
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
