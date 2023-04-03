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
          backgroundColor: Colors.grey,
          title: const Center(
            child: Text(
              'Insert an URL',
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    hintText: 'Enter a url',
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(),
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
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (urlController.text.isEmpty) {
                        // User did not type anything and accepted
                        SnackBar snackbar = SnackBarMessage.snackBarMessage(
                          message: 'You have to enter a valid url!',
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      } else {
                        newUrl = urlController.text;
                        Navigator.maybePop(context, newUrl);
                      }
                    },
                    child: const Text(
                      'Use this url',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.maybePop(context, 'deletecurrenturl');

                    },
                    child: const Text(
                      'Remove current url',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  // Cancel button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.maybePop(context, null);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
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
