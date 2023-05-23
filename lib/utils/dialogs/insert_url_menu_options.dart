import 'package:flutter/material.dart';

import '../../l10n/l10n_export.dart';
import '../icons/insert_url_icon_icons.dart';
import '../snackbars/snackbar_message.dart';
import '../styles/dialog_subtitle_style.dart';
import '../styles/dialog_title_style.dart';

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
          title: DialogTitleStyle(
              title: AppLocalizations.of(context)!.url_dialog_title),
          content: SingleChildScrollView(
            reverse: true,
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Explanation
                DialogSubtitleStyle(
                    subtitle:
                        AppLocalizations.of(context)!.url_dialog_explanation),
                const SizedBox(
                  height: 16,
                ),
                // Insert url
                Container(
                  color: Colors.grey.shade800.withOpacity(0.7),
                  child: TextFormField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.white),
                      hintText: AppLocalizations.of(context)!
                          .url_dialog_textformfieldUrlInput,
                      prefixIcon: const Icon(
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
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (urlController.text.isEmpty) {
                        // User did not type anything and accepted
                        SnackBar snackbar = SnackBarMessage.snackBarMessage(
                          message: AppLocalizations.of(context)!
                              .url_dialogSnackbar_invalidUrl,
                          backgroundColor: Colors.red.shade500,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      } else {
                        newUrl = urlController.text;
                        Navigator.maybePop(context, newUrl);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.url_dialog_confirmButton,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Visibility(
                    visible: (widget.currentNoteUrl != null),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          minimumSize: const Size(200, 40),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.maybePop(context, 'deletecurrenturl');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.url_dialog_deleteButton,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontStyle: FontStyle.italic),
                        ),
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
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.maybePop(context, null);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.cancelButton,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
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
