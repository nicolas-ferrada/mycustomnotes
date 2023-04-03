import 'package:flutter/material.dart';

import '../snackbars/snackbar_message.dart';

class InsertMenuOptions extends StatefulWidget {
  final BuildContext context;

  const InsertMenuOptions({
    required this.context,
    Key? key,
  }) : super(key: key);

  @override
  State<InsertMenuOptions> createState() => _InsertMenuOptionsState();
}

class _InsertMenuOptionsState extends State<InsertMenuOptions> {
  String newUrl = '';
  TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: const Color.fromRGBO(250, 216, 90, 0.8),
          title: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.grey.shade800.withOpacity(0.9),
              child: const Text(
                'Insert a URL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey.shade800.withOpacity(0.7),
                  child: TextFormField(
                    controller: urlController,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.red,
                      hintText: 'Enter your url',
                      prefixIcon: Icon(
                        Icons.link,
                        color: Colors.white,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.grey.shade800.withOpacity(0.9),
                    ),
                    onPressed: () {
                      if (urlController.text.isEmpty) {
                        // User did not type anything and accepted
                        SnackBar snackbar = SnackBarMessage.snackBarMessage(
                          message: 'You have to enter a valid url',
                          backgroundColor: Colors.red.shade500,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      } else {
                        newUrl = urlController.text;
                        Navigator.maybePop(context, newUrl);
                      }
                    },
                    child: const Text(
                      'Use this url',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.grey.shade800.withOpacity(0.9),
                    ),
                    onPressed: () {
                      Navigator.maybePop(context, 'deletecurrenturl');
                    },
                    child: const Text(
                      'Remove current url',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Cancel button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.grey.shade800.withOpacity(0.9),
                    ),
                    onPressed: () {
                      Navigator.maybePop(context, null);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
