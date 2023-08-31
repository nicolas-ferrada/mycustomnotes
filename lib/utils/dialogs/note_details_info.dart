import 'package:flutter/material.dart';
import '../../l10n/l10n_export.dart';

import '../formatters/date_formatter.dart';

// ignore: must_be_immutable
class NotesDetails extends StatelessWidget {
  BuildContext context;
  dynamic note;
  NotesDetails({
    super.key,
    required this.context,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 3,
      backgroundColor: Colors.grey.shade400,
      title: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade800.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            textAlign: TextAlign.center,
            AppLocalizations.of(context)!.info_dialog_title,
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
        child: FutureBuilder<List<String>>(
            future: getDates(note),
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
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
                              snapshot.data![0],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
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
                                  .info_dialog_lastModificationDate,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                            Text(
                              snapshot.data![1],
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

  Future<List<String>> getDates(dynamic note) async {
    final String createdDate = await DateFormatter.showDateFormattedAllFields(
        dateDB: note.createdDate, context: context);
    final String lastDate = await DateFormatter.showDateFormattedAllFields(
        dateDB: note.lastModificationDate, context: context);

    return [createdDate, lastDate];
  }
}
