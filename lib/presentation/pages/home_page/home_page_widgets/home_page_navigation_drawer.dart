import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:mycustomnotes/presentation/pages/about_page/about_page.dart';
import '../../../../data/models/Note/folder_model.dart';
import '../../../../data/models/Note/note_tasks_model.dart';
import '../../../../data/models/Note/note_text_model.dart';
import '../../../../data/models/User/user_configuration.dart';
import '../../../../domain/services/user_configuration_service.dart';
import '../../../../l10n/change_language.dart';
import '../../../../utils/dialogs/user_configuration_dialogs/user_configuration_date_time_format.dart';
import '../../../../utils/dialogs/user_configuration_dialogs/user_configuration_notes_view.dart';
import '../../../../utils/enums/select_language_enum.dart';
import '../../../../l10n/l10n_export.dart';
import '../../../../utils/dialogs/confirmation_dialog.dart';
import '../../../../utils/dialogs/change_language_dialog.dart';
import '../../../../utils/enums/notes_view_enum.dart';
import '../../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../account_security_privacy_page/account_security_privacy_page.dart';

class NavigationDrawerHomePage extends StatelessWidget {
  final User currentUser;
  final UserConfiguration userConfiguration;
  final Function updateUserConfiguration;

  final List<NoteText> notesTextList;
  final List<NoteTasks> notesTasksList;
  final List<Folder> folders;

  const NavigationDrawerHomePage({
    super.key,
    required this.currentUser,
    required this.userConfiguration,
    required this.updateUserConfiguration,
    required this.notesTextList,
    required this.notesTasksList,
    required this.folders,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      width: 250,
      child: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        runSpacing: 8,
        children: [
          // Title
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.title_drawer_homePage,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ), // Change language
          const Divider(thickness: 1),
          changeLanguage(context: context),
          const Divider(thickness: 1),
          dateAndHourStyle(context: context),
          const Divider(thickness: 1),
          notesStyleVisualization(context: context),
          const Divider(thickness: 1),
          accountSecurityAndPrivacy(context: context),
          const Divider(thickness: 1),
          about(context: context),
          const Divider(thickness: 1),
          logout(context: context),
          const Divider(thickness: 1),
        ],
      ),
    );
  }

  Widget changeLanguage({
    required BuildContext context,
  }) {
    return ListTile(
      onTap: () async {
        try {
          final SelectLanguage? language = await showDialog<SelectLanguage?>(
            context: context,
            builder: (context) {
              return ChangeLanguageDialog(
                context: context,
              );
            },
          );
          if (language != null && context.mounted) {
            await ChangeLanguage.changeLanguage(
                context: context, language: language.lenguageId);
          }
        } catch (errorMessage) {
          // errorMessage is the custom message probably sent by the user configuration functions
          ExceptionsAlertDialog.showErrorDialog(
              context: context, errorMessage: errorMessage.toString());
        }
      },
      leading: const Icon(Icons.language, size: 28),
      title: Text(
        AppLocalizations.of(context)!.language_drawer_homePage,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget dateAndHourStyle({
    required BuildContext context,
  }) {
    return ListTile(
      onTap: () async {
        try {
          final String? dateTimeFormat = await showDialog<String?>(
            context: context,
            builder: (context) {
              return ChangeNoteDateTimeFormat(
                userConfiguration: userConfiguration,
                context: context,
              );
            },
          );
          if (dateTimeFormat != null && context.mounted) {
            UserConfigurationService.editUserConfigurations(
                    context: context,
                    userId: currentUser.uid,
                    dateTimeFormat: dateTimeFormat)
                .then((_) async {
              updateUserConfiguration();
              Navigator.maybePop(context);
            });
          }
        } catch (errorMessage) {
          // errorMessage is the custom message probably sent by the user configuration functions
          ExceptionsAlertDialog.showErrorDialog(
              context: context, errorMessage: errorMessage.toString());
        }
      },
      leading: const Icon(Icons.date_range, size: 28),
      title: Text(
        AppLocalizations.of(context)!.dateAndTime_drawer_homePage,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget notesStyleVisualization({
    required BuildContext context,
  }) {
    return ListTile(
      onTap: () async {
        try {
          NotesView? userNoteView = await showDialog<NotesView?>(
            context: context,
            builder: (context) {
              return ChangeNotesView(
                userConfiguration: userConfiguration,
                context: context,
              );
            },
          );
          if (userNoteView != null && context.mounted) {
            UserConfigurationService.editUserConfigurations(
                    context: context,
                    userId: currentUser.uid,
                    notesView: userNoteView.notesViewId)
                .then((_) async {
              updateUserConfiguration();
              Navigator.maybePop(context);
            });
          }
        } catch (errorMessage) {
          // errorMessage is the custom message probably sent by the user configuration functions
          ExceptionsAlertDialog.showErrorDialog(
              context: context, errorMessage: errorMessage.toString());
        }
      },
      leading: const Icon(Icons.grid_view, size: 28),
      title: Text(
        AppLocalizations.of(context)!.notesView_drawer_homePage,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget accountSecurityAndPrivacy({
    required BuildContext context,
  }) {
    return ListTile(
      onTap: () async {
        try {
          Navigator.maybePop(context).then(
            (_) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountSecurityPrivacyPage(
                  currentUser: currentUser,
                  folders: folders,
                  notesTasksList: notesTasksList,
                  notesTextList: notesTextList,
                ),
              ),
            ),
          );
        } catch (errorMessage) {
          ExceptionsAlertDialog.showErrorDialog(
              context: context, errorMessage: errorMessage.toString());
        }
      },
      leading: const Icon(Icons.lock, size: 28),
      title: Text(
        AppLocalizations.of(context)!.accountSecurityAndPrivacy_drawer_homePage,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget about({
    required BuildContext context,
  }) {
    return ListTile(
      onTap: () async {
        try {
          Navigator.maybePop(context).then(
            (_) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutPage(),
              ),
            ),
          );
        } catch (errorMessage) {
          ExceptionsAlertDialog.showErrorDialog(
              context: context, errorMessage: errorMessage.toString());
        }
      },
      leading: const Icon(Icons.info, size: 28),
      title: Text(
        AppLocalizations.of(context)!.about_text_aboutPage,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget logout({
    required BuildContext context,
  }) {
    return ListTile(
      onTap: () {
        ConfirmationDialog.logOutDialog(context, currentUser);
      },
      leading: Transform.scale(
        scaleX: -1,
        child: const Icon(
          Icons.logout,
          size: 28,
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.logOut_drawer_homePage,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
