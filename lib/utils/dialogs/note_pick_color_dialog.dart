import 'package:flutter/material.dart';
import '../../l10n/l10n_export.dart';

import '../note_color/note_color.dart';

class NotePickColorDialog extends StatefulWidget {
  const NotePickColorDialog({
    super.key,
  });

  @override
  State<NotePickColorDialog> createState() => _NotePickColorDialogState();
}

class _NotePickColorDialogState extends State<NotePickColorDialog> {
  final double colorIconSize = 58;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return AlertDialog(
          elevation: 3,
          contentPadding: const EdgeInsets.all(12),
          backgroundColor: Colors.grey.shade400,
          title: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade800.withOpacity(0.8),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                textAlign: TextAlign.center,
                AppLocalizations.of(context)!.color_dialog_title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          content: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade800.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(30))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // YELLOW COLOR
                      InkWell(
                        onTap: () {
                          Navigator.maybePop(context, NoteColor.ambar);
                        },
                        customBorder: const CircleBorder(),
                        child: Icon(
                          Icons.circle,
                          size: colorIconSize,
                          color: NoteColor.ambar.getColor,
                        ),
                      ),
                      // GREEN COLOR
                      InkWell(
                        onTap: () {
                          Navigator.maybePop(context, NoteColor.green);
                        },
                        customBorder: const CircleBorder(),
                        child: Icon(
                          Icons.circle,
                          size: colorIconSize,
                          color: NoteColor.green.getColor,
                        ),
                      ),
                      // BLUE COLOR
                      InkWell(
                        onTap: () {
                          Navigator.maybePop(context, NoteColor.lightBlue);
                        },
                        customBorder: const CircleBorder(),
                        child: Icon(
                          Icons.circle,
                          size: colorIconSize,
                          color: NoteColor.lightBlue.getColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ORANGE COLOR
                      InkWell(
                        onTap: () {
                          Navigator.maybePop(context, NoteColor.orange);
                        },
                        customBorder: const CircleBorder(),
                        child: Icon(
                          Icons.circle,
                          size: colorIconSize,
                          color: NoteColor.orange.getColor,
                        ),
                      ),
                      // PINK COLOR
                      InkWell(
                        onTap: () {
                          Navigator.maybePop(context, NoteColor.pink);
                        },
                        customBorder: const CircleBorder(),
                        child: Icon(
                          Icons.circle,
                          size: colorIconSize,
                          color: NoteColor.pink.getColor,
                        ),
                      ),
                      // TEAL COLOR
                      InkWell(
                        onTap: () {
                          Navigator.maybePop(context, NoteColor.teal);
                        },
                        customBorder: const CircleBorder(),
                        child: Icon(
                          Icons.circle,
                          size: colorIconSize,
                          color: NoteColor.teal.getColor,
                        ),
                      ),
                      // LIGHT RED COLOR
                      InkWell(
                        onTap: () {
                          Navigator.maybePop(context, NoteColor.lightRed);
                        },
                        customBorder: const CircleBorder(),
                        child: Icon(
                          Icons.circle,
                          size: colorIconSize,
                          color: NoteColor.lightRed.getColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  minimumSize: const Size(200, 40),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.maybePop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.cancelButton,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
