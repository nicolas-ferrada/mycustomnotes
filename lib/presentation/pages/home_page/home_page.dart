import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter/material.dart';
import '../../../data/models/Note/folder_notifier.dart';
import '../../../domain/services/folder_service.dart';
import 'package:provider/provider.dart';

import '../../../data/models/Note/folder_model.dart';
import '../../../data/models/Note/note_notifier.dart';
import '../../../data/models/Note/note_tasks_model.dart';
import '../../../data/models/Note/note_text_model.dart';
import '../../../data/models/User/user_configuration.dart';
import '../../../domain/services/note_tasks_service.dart';
import '../../../domain/services/note_text_service.dart';
import '../../../domain/services/user_configuration_service.dart';
import '../../../l10n/l10n_export.dart';
import 'home_page_widgets/home_page_app_bar.dart';
import 'home_page_widgets/home_page_build_notes_folders_widget.dart';
import 'home_page_widgets/home_page_navigation_drawer.dart';
import 'home_page_widgets/home_page_bottom_navigator_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User currentUser = FirebaseAuth.instance.currentUser!;
  late UserConfiguration userConfiguration;

  @override
  void initState() {
    super.initState();
    getUserConfiguration();
  }

  Future<UserConfiguration> getUserConfiguration() async {
    return await UserConfigurationService.getUserConfigurations(
      userId: currentUser.uid,
      context: context,
    );
  }

  // Callback to update user config
  void updateUserConfiguration() async {
    userConfiguration = await getUserConfiguration();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FolderNotifier>(builder: (context, folderNotifier, _) {
      return FutureBuilder<UserConfiguration>(
        future: getUserConfiguration(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userConfiguration = snapshot.data!;
            return StreamBuilder<List<Folder>>(
              stream: FolderService.readAllFolders(
                userId: currentUser.uid,
                context: context,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Folder> folders = snapshot.data!;
                  return buildNoteWidget(folders: folders, context: context);
                } else if (snapshot.hasError) {
                  return buildErrorWidget(context, snapshot.error.toString());
                } else {
                  return buildLoadingWidget();
                }
              },
            );
          } else if (snapshot.hasError) {
            return buildErrorWidget(context, snapshot.error.toString());
          } else {
            return buildLoadingWidget();
          }
        },
      );
    });
  }

  Widget buildErrorWidget(BuildContext context, String errorMessage) {
    return Scaffold(
      body: Center(
        child: Text(
          errorMessage,
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

  Widget buildNoteWidget({
    required BuildContext context,
    required List<Folder> folders,
  }) {
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
                      folders: folders,
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
    required List<Folder> folders,
  }) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBarHomePage(
          tasksNotes: tasksNotes,
          textNotes: textNotes,
          userConfiguration: userConfiguration,
          folders: folders,
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
        folders: folders,
        currentUser: currentUser,
        updateUserConfiguration: updateUserConfiguration,
      ),
      // Create note and folder
      bottomNavigationBar: BottomNavigationBarHomePage(
        notesTasksList: tasksNotes,
        notesTextList: textNotes,
        userConfiguration: userConfiguration,
      ),
    );
  }

  Widget buildNoteBodyWidget({
    required BuildContext context,
    required List<NoteText> textNotes,
    required List<NoteTasks> tasksNotes,
    required List<Folder> folders,
    required currentUser,
    required updateUserConfiguration,
  }) {
    if (textNotes.isEmpty && tasksNotes.isEmpty && folders.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noNotesCreated_text_homePage,
        ),
      );
    } else {
      return HomePageBuildNotesAndFoldersWidget(
        notesTextList: textNotes,
        notesTasksList: tasksNotes,
        userConfiguration: userConfiguration,
        folders: folders,
        currentUser: currentUser,
        updateUserConfiguration: updateUserConfiguration,
        editingFromSearchBar: false,
      );
    }
  }
}
