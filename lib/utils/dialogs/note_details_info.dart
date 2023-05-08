import 'package:flutter/material.dart';

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
      backgroundColor: Colors.grey,
      title: const Center(
        child: Text('Note details'),
      ),
      content: FutureBuilder<List<String>>(
          future: getDates(note),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Creation date:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    snapshot.data![0],
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  const Text(
                    'Last modification date:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    snapshot.data![1],
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          }),
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
                  'Close',
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
  }

  Future<List<String>> getDates(dynamic note) async {
    final String createdDate = await DateFormatter.showDateFormattedAllFields(
        dateDB: note.createdDate, context: context);
    final String lastDate = await DateFormatter.showDateFormattedAllFields(
        dateDB: note.lastModificationDate, context: context);

    return [createdDate, lastDate];
  }
}
