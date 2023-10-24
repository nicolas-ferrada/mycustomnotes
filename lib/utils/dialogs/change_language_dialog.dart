import 'package:flutter/material.dart';
import 'package:mycustomnotes/utils/app_color_scheme/app_color_scheme.dart';

import '../../l10n/change_language.dart';
import '../../l10n/l10n_export.dart';
import '../enums/select_language_enum.dart';
import '../styles/dialog_title_style.dart';

class ChangeLanguageDialog extends StatefulWidget {
  final BuildContext context;
  const ChangeLanguageDialog({
    super.key,
    required this.context,
  });

  @override
  State<ChangeLanguageDialog> createState() => _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState extends State<ChangeLanguageDialog> {
  SelectLanguage? currentLanguage;

  getCurrentLanguage({
    required String language,
  }) {
    switch (language) {
      case 'en':
        return SelectLanguage.english;
      case 'es':
        return SelectLanguage.spanish;
      case 'de':
        return SelectLanguage.german;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: ChangeLanguage.getLanguage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          currentLanguage = getCurrentLanguage(language: snapshot.data!);
          return Builder(
            builder: (BuildContext context) {
              return AlertDialog(
                elevation: 3,
                backgroundColor: Colors.grey.shade400,
                title: Center(
                    child: DialogTitleStyle(
                  title: AppLocalizations.of(context)!
                      .languageTitle_drawerDialog_homePage,
                )),
                content: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          englishCardOption(context),
                          spanishCardOption(context),
                          germanCardOption(context),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800.withOpacity(0.8),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              (currentLanguage != null)
                                  ? '${AppLocalizations.of(context)!.languageCurrentLanguageSelected_drawerDialog_homePage}\n${currentLanguage!.languageName(context: context, currentLanguage: currentLanguage!)}'
                                  : 'No language selected/No hay language seleccionado',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
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
                            AppLocalizations.of(context)!.cancelButton,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("A problem has ocurred"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return const Center(child: Text("A problem has ocurred"));
        }
      },
    );
  }

  Widget englishCardOption(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: 60,
        width: 150,
        child: Card(
          elevation: 10,
          color:
              (currentLanguage?.languageId == SelectLanguage.english.languageId)
                  ? AppColorScheme.purple()
                  : Colors.grey.shade800.withOpacity(0.9),
          child: InkWell(
            onTap: () {
              Navigator.maybePop(context, SelectLanguage.english);
            },
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'English',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget spanishCardOption(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: 60,
        width: 150,
        child: Card(
          elevation: 10,
          color:
              (currentLanguage?.languageId == SelectLanguage.spanish.languageId)
                  ? AppColorScheme.purple()
                  : Colors.grey.shade800.withOpacity(0.9),
          child: InkWell(
            onTap: () {
              Navigator.maybePop(context, SelectLanguage.spanish);
            },
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Español',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget germanCardOption(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: 60,
        width: 150,
        child: Card(
          elevation: 10,
          color:
              (currentLanguage?.languageId == SelectLanguage.german.languageId)
                  ? AppColorScheme.purple()
                  : Colors.grey.shade800.withOpacity(0.9),
          child: InkWell(
            onTap: () {
              Navigator.maybePop(context, SelectLanguage.german);
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Deutsch',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
