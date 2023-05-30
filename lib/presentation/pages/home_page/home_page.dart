import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/Note/note_notifier.dart';
import '../../../data/models/Note/note_tasks_model.dart';
import '../../../data/models/Note/note_text_model.dart';
import '../../../data/models/User/user_configuration.dart';
import '../../../domain/services/auth_user_service.dart';
import '../../../domain/services/note_tasks_service.dart';
import '../../../domain/services/note_text_service.dart';
import '../../../domain/services/user_configuration_service.dart';
import '../../../l10n/l10n_export.dart';
import 'home_page_widgets/home_page_app_bar.dart';
import 'home_page_widgets/home_page_build_notes_widget.dart';
import 'home_page_widgets/home_page_navigation_drawer.dart';
import 'home_page_widgets/home_page_new_note_button_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User currentUser = AuthUserService.getCurrentUserFirebase();
  late UserConfiguration userConfiguration;

  @override
  void initState() {
    super.initState();
    getUserConfiguration();
  }

  void updateUserConfiguration() async {
    userConfiguration = await getUserConfiguration();
    setState(() {});
  }

  Future<UserConfiguration> getUserConfiguration() async {
    return await UserConfigurationService.getUserConfigurations(
        userId: currentUser.uid, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserConfiguration>(
      future: getUserConfiguration(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          userConfiguration = snapshot.data!;
          return buildNoteWidget(context);
        } else if (snapshot.hasError) {
          return buildErrorWidget(context);
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget buildErrorWidget(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppLocalizations.of(context)!
              .getUserConfigurationError_snapshotHasError_homePage,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildLoadingWidget() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: loadingAppBar(),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget loadingAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'My Custom Notes',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget buildErrorTextWidget(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.getNotesError_snapshotHasError_homePage,
    );
  }

  Widget buildNoteWidget(BuildContext context) {
    return Consumer<NoteNotifier>(
      builder: (context, noteNotifier, _) {
        return StreamBuilder(
          stream: NoteTasksService.readAllNotesTasks(
            userId: currentUser.uid,
            context: context,
          ),
          builder: (context, snapshotNoteTasks) {
            if (snapshotNoteTasks.hasError) {
              return buildErrorTextWidget(context);
            } else {
              return StreamBuilder(
                stream: NoteTextService.readAllNotesText(
                  userId: currentUser.uid,
                  context: context,
                ),
                builder: (context, snapshotNoteText) {
                  if (snapshotNoteText.hasError) {
                    return buildErrorTextWidget(context);
                  } else if (snapshotNoteText.hasData &&
                      snapshotNoteTasks.hasData) {
                    final List<NoteText> textNotes = snapshotNoteText.data!;
                    final List<NoteTasks> tasksNotes = snapshotNoteTasks.data!;
                    return buildNoteScaffoldWidget(
                      context: context,
                      textNotes: textNotes,
                      tasksNotes: tasksNotes,
                    );
                  } else {
                    return buildLoadingWidget();
                  }
                },
              );
            }
          },
        );
      },
    );
  }

  Widget buildNoteScaffoldWidget({
    required BuildContext context,
    required List<NoteText> textNotes,
    required List<NoteTasks> tasksNotes,
  }) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBarHomePage(
          tasksNotes: tasksNotes,
          textNotes: textNotes,
          userConfiguration: userConfiguration,
        ),
      ),
      drawer: NavigationDrawerHomePage(
        currentUser: currentUser,
        userConfiguration: userConfiguration,
        updateUserConfiguration: updateUserConfiguration,
      ),
      body: buildNoteBodyWidget(
        context: context,
        textNotes: textNotes,
        tasksNotes: tasksNotes,
      ),
      floatingActionButton: newNoteButton(context: context),
    );
  }

  Widget buildNoteBodyWidget({
    required BuildContext context,
    required List<NoteText> textNotes,
    required List<NoteTasks> tasksNotes,
  }) {
    if (textNotes.isEmpty && tasksNotes.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noNotesCreated_text_homePage,
        ),
      );
    } else {
      return HomePageBuildNotesWidget(
        notesTextList: textNotes,
        notesTasksList: tasksNotes,
        userConfiguration: userConfiguration,
      );
    }
  }
}
