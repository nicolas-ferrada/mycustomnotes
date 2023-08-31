import 'package:flutter/material.dart';
import '../../app_color_scheme/app_color_scheme.dart';
import '../../styles/dialog_title_style.dart';

import '../../../data/models/User/user_configuration.dart';
import '../../../l10n/l10n_export.dart';
import '../../enums/notes_view_enum.dart';
import '../../icons/notes_view_icons_icons.dart';

class ChangeNotesView extends StatefulWidget {
  final BuildContext context;
  final UserConfiguration userConfiguration;
  const ChangeNotesView({
    super.key,
    required this.context,
    required this.userConfiguration,
  });

  @override
  State<ChangeNotesView> createState() => _ChangeNotesViewState();
}

class _ChangeNotesViewState extends State<ChangeNotesView> {
  NotesView? notesView;

  @override
  void initState() {
    super.initState();
    notesView = getCurrentLanguage(
        noteView: widget.userConfiguration.notesView, context: context);
  }

  NotesView getCurrentLanguage({
    required int noteView,
    required BuildContext context,
  }) {
    switch (noteView) {
      case 1:
        return NotesView.small;
      case 2:
        return NotesView.split;
      case 3:
        return NotesView.large;
      default:
        throw Exception(
            AppLocalizations.of(context)!.unexpectedException_dialog);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return AlertDialog(
        elevation: 3,
        backgroundColor: Colors.grey.shade400,
        title: Center(
          child: DialogTitleStyle(
            title: AppLocalizations.of(context)!
                .notesViewTitle_drawerDialog_homePage,
            fontSize: 32,
          ),
        ),
        content: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Card(
                        elevation: 10,
                        color: (notesView?.notesViewId == 1)
                            ? AppColorScheme.purple()
                            : Colors.grey.shade800.withOpacity(0.9),
                        child: InkWell(
                          onTap: () {
                            notesView = NotesView.small;
                            Navigator.of(context).pop(notesView);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 8),
                              const Icon(
                                NotesViewIcons.smallList,
                                size: 38,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .smallNotesViewOption_drawerDialog_homePage,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 11),
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
                        color: (notesView?.notesViewId == 2)
                            ? AppColorScheme.purple()
                            : Colors.grey.shade800.withOpacity(0.9),
                        child: InkWell(
                          onTap: () {
                            notesView = NotesView.split;
                            Navigator.of(context).pop(notesView);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 8),
                              const Icon(
                                NotesViewIcons.splitList,
                                size: 38,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .splitNotesViewOption_drawerDialog_homePage,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
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
                        color: (notesView?.notesViewId == 3)
                            ? AppColorScheme.purple()
                            : Colors.grey.shade800.withOpacity(0.9),
                        child: InkWell(
                          onTap: () {
                            notesView = NotesView.large;
                            Navigator.of(context).pop(notesView);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 8),
                              const Icon(
                                Icons.square,
                                size: 42,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .largeNotesViewOption_drawerDialog_homePage,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
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
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.withOpacity(0.8),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Text(
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        (notesView != null)
                            ? '${AppLocalizations.of(context)!.viewSelectedNotesViewInfo_drawerDialog_homePage}\n ${notesView!.noteViewName(currentView: notesView!, context: context)}'
                            : 'No view selected/No hay vista seleccionada',
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
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
