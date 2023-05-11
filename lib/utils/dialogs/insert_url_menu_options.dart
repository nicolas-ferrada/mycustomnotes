import 'package:flutter/material.dart';

import '../icons/insert_url_icon_icons.dart';
import '../snackbars/snackbar_message.dart';

class InsertUrlMenuOptions extends StatefulWidget {
  final BuildContext context;
  final String? currentNoteUrl;

  const InsertUrlMenuOptions({
    required this.context,
    required this.currentNoteUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<InsertUrlMenuOptions> createState() => _InsertUrlMenuOptionsState();
}

class _InsertUrlMenuOptionsState extends State<InsertUrlMenuOptions> {
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          content: SingleChildScrollView(
            reverse: true,
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Explanation
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  color: Colors.grey.shade800.withOpacity(0.8),
                  child: const Text(
                    'You can paste any internet url to show it in your text notes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
                // Insert url
                Container(
                  color: Colors.grey.shade800.withOpacity(0.7),
                  child: TextFormField(
                    controller: urlController,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Enter a url',
                      prefixIcon: Icon(
                        InsertUrlIcon.link,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                    height: 4,
                  ),
                  Visibility(
                    visible: (widget.currentNoteUrl != null),
                    child: ElevatedButton(
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
                  ),
                  const SizedBox(
                    height: 4,
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
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
