import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:mycustomnotes/presentation/pages/account_security_privacy_page/account_security_privacy_page_widgets/privacy_widget.dart';
import '../../../data/models/Note/folder_model.dart';
import '../../../data/models/Note/note_tasks_model.dart';
import '../../../data/models/Note/note_text_model.dart';
import '../../../domain/services/auth_services.dart/auth_user_service.dart';
import '../../../l10n/l10n_export.dart';
import '../../../utils/enums/user_auth_provider.dart';
import 'account_security_privacy_page_widgets/my_account_widget.dart';
import 'account_security_privacy_page_widgets/security_widget.dart';

class AccountSecurityPrivacyPage extends StatefulWidget {
  final User currentUser;
  final List<NoteText> notesTextList;
  final List<NoteTasks> notesTasksList;
  final List<Folder> folders;
  const AccountSecurityPrivacyPage({
    super.key,
    required this.currentUser,
    required this.notesTextList,
    required this.notesTasksList,
    required this.folders,
  });

  @override
  State<AccountSecurityPrivacyPage> createState() =>
      _AccountSecurityPrivacyPageState();
}

class _AccountSecurityPrivacyPageState
    extends State<AccountSecurityPrivacyPage> {
  late final UserAuthProvider userAuthProvider;

  @override
  void initState() {
    super.initState();
    userAuthProvider = AuthUserService.getUserAuthProvider(
      currentUser: widget.currentUser,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!
              .accountSecurityAndPrivacy_drawer_homePage,
          style: const TextStyle(fontSize: 17),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: MyAccountWidget(
            currentUser: widget.currentUser,
            userAuthProvider: userAuthProvider,
          )),
          Expanded(
              child: SecurityWidget(
            currentUser: widget.currentUser,
            userAuthProvider: userAuthProvider,
          )),
          Expanded(
            child: PrivacyWidget(
              currentUser: widget.currentUser,
              notesTextList: widget.notesTextList,
              notesTasksList: widget.notesTasksList,
              folders: widget.folders,
              userAuthProvider: userAuthProvider,
            ),
          ),
        ],
      ),
    );
  }
}
