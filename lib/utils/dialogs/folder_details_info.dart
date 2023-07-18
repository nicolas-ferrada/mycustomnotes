import 'package:flutter/material.dart';
import '../../l10n/l10n_export.dart';

import '../../data/models/Note/folder_model.dart';
import '../formatters/date_formatter.dart';

// ignore: must_be_immutable
class FolderDetailsInfo extends StatelessWidget {
  BuildContext context;
  Folder folder;
  FolderDetailsInfo({
    super.key,
    required this.context,
    required this.folder,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 3,
      backgroundColor: const Color.fromRGBO(250, 216, 90, 0.8),
      title: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade800.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            textAlign: TextAlign.center,
            AppLocalizations.of(context)!.infoFolder_dialog_title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      content: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: FutureBuilder<String>(
            future: getDates(folder),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade800.withOpacity(0.8),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .info_dialog_creationDate,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            Text(
                              snapshot.data!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  AppLocalizations.of(context)!.unexpectedException_dialog,
                  textAlign: TextAlign.center,
                ));
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
      actions: [
        Center(
          child: Column(
            children: [
              // Close button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 10,
                    minimumSize: const Size(200, 40),
                    backgroundColor: Colors.white),
                onPressed: () {
                  Navigator.maybePop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.closeButton,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<String> getDates(Folder folder) async {
    final String createdDate = await DateFormatter.showDateFormattedAllFields(
        dateDB: folder.createdDate, context: context);

    return createdDate;
  }
}
