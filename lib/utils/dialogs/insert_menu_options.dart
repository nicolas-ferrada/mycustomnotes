import 'package:flutter/material.dart';
import 'package:mycustomnotes/utils/snackbars/snackbar_message.dart';

class InsertMenuOptions {
  // Insert menu pick image/video
  static Future<String> selectImageVideoDialog({
    required BuildContext context,
  }) async {
    String newUrl = '';
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.grey,
          title: const Center(
            child: Text('Choose an option'),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  Navigator.maybePop(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.image, size: 46),
                    Text('Image'),
                  ],
                ),
              ),
              const SizedBox(
                width: 36,
              ),
              InkWell(
                onTap: () async {
                  await enterYoutubeUrlDialog(context: context).then((dbUrl) {
                    newUrl = dbUrl;
                    return newUrl;
                  }).then((_) => Navigator.maybePop(context));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.play_circle, size: 46),
                    Text('Video'),
                  ],
                ),
              )
            ],
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  // Close button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
    return newUrl;
  }

  // Enter youtube video url dialog
  static Future<String> enterYoutubeUrlDialog({
    required BuildContext context,
  }) async {
    TextEditingController urlController = TextEditingController();
    String url = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.grey,
          title: const Center(
            child: Text('Youtube URL'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: urlController,
                decoration: const InputDecoration(
                  hintText:
                      'Paste link here',
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (urlController.text.isEmpty) {
                    // user did not type anything and accepted
                    SnackBarMessage.snackBarMessage(
                        message: 'You have to type a youtube url',
                        backgroundColor: Colors.grey);
                  } else {
                    // User did type something
                    url = urlController.text;
                    Navigator.pop(context);
                  }
                },
                child: const Text('Use this video'),
              )
            ],
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  // Close button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    return url;
  }
}
