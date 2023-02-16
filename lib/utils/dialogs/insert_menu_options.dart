import 'package:flutter/material.dart';
import 'package:mycustomnotes/utils/snackbars/snackbar_message.dart';

class InsertMenuOptions extends StatefulWidget {
  final BuildContext context;
  final String? noteCurrentUrl;
  const InsertMenuOptions(
      {super.key, required this.context, this.noteCurrentUrl});

  @override
  State<InsertMenuOptions> createState() => _InsertMenuOptionsState();
}

class _InsertMenuOptionsState extends State<InsertMenuOptions> {
  String? newUrl;
  bool isVideoSelected = false;
  TextEditingController urlController = TextEditingController();
  @override
  void initState() {
    super.initState();
    newUrl = widget.noteCurrentUrl;
  }

  @override
  Widget build(BuildContext context) {
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
              setState(() {
                isVideoSelected = false;
                Navigator.maybePop(context);
              });
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
              setState(() {
                isVideoSelected = true;
              });
              isVideoSelected = true;
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
              // Text enter link
              Visibility(
                visible: isVideoSelected,
                child: TextFormField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    hintText: 'Enter a youtube url',
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              // Apply url button hidden
              Visibility(
                visible: isVideoSelected,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.white),
                  onPressed: () {
                    if (urlController.text.isEmpty) {
                      // user did not type anything and accepted
                      SnackBar snackbar = SnackBarMessage.snackBarMessage(
                          message: 'You have to enter a youtube url',
                          backgroundColor: Colors.grey);
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    } else {
                      // User did type something
                      newUrl = urlController.text;
                      isVideoSelected = false;
                      Navigator.of(context).pop(newUrl);
                    }
                  },
                  child: const Text(
                    'Use this video',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              // Cancel button
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
                height: 10,
              )
            ],
          ),
        ),
      ],
    );
  }
}
