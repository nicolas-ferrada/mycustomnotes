import 'package:flutter/material.dart';

import '../../../data/models/User/user_configuration.dart';
import '../../enums/select_language_enum.dart';

class ChangeLanguage extends StatefulWidget {
  final BuildContext context;
  final UserConfiguration userConfiguration;
  const ChangeLanguage({
    super.key,
    required this.context,
    required this.userConfiguration,
  });

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  SelectLanguage? currentLanguage;

  @override
  void initState() {
    super.initState();
    currentLanguage =
        getCurrentLanguage(languageId: widget.userConfiguration.language);
  }

  getCurrentLanguage({
    required String languageId,
  }) {
    switch (languageId) {
      case 'EN':
        return SelectLanguage.english;
      case 'ES':
        return SelectLanguage.spanish;
      default:
        return Exception('Language not found...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: const Color.fromRGBO(250, 216, 90, 0.8),
          title: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.grey.shade800.withOpacity(0.9),
              child: const Text(
                'Select language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Card(
                      elevation: 10,
                      color: (currentLanguage?.languageIndex == 1)
                          ? Colors.red
                          : Colors.grey.shade800.withOpacity(0.9),
                      child: InkWell(
                        onTap: () {
                          Navigator.maybePop(context, SelectLanguage.english);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(height: 8),
                            Icon(
                              Icons.language,
                              size: 38,
                              color: Colors.white,
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'English',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Card(
                      elevation: 10,
                      color: (currentLanguage?.languageIndex == 2)
                          ? Colors.red
                          : Colors.grey.shade800.withOpacity(0.9),
                      child: InkWell(
                        onTap: () {
                          Navigator.maybePop(context, SelectLanguage.spanish);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(height: 8),
                            Icon(
                              Icons.language,
                              size: 38,
                              color: Colors.white,
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Spanish',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    color: Colors.grey.shade800.withOpacity(0.9),
                    child: Text(
                      (currentLanguage != null)
                          ? 'Current language selected:\n${currentLanguage!.languageName}'
                          : 'No language selected',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
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
                  // Close button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.grey.shade800.withOpacity(0.9)),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
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