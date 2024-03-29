import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mycustomnotes/utils/enums/user_auth_provider.dart';

import '../../../../data/models/Note/folder_model.dart';
import '../../../../data/models/Note/note_tasks_model.dart';
import '../../../../data/models/Note/note_text_model.dart';
import '../../../../l10n/l10n_export.dart';
import '../../../../utils/dialogs/successful_message_dialog.dart';
import '../../delete_account_page/delete_account_page.dart';
import '../../export_data_page/export_data_page.dart';

class PrivacyWidget extends StatefulWidget {
  final User currentUser;
  final List<NoteText> notesTextList;
  final List<NoteTasks> notesTasksList;
  final List<Folder> folders;
  final UserAuthProvider userAuthProvider;
  const PrivacyWidget({
    super.key,
    required this.currentUser,
    required this.notesTextList,
    required this.notesTasksList,
    required this.folders,
    required this.userAuthProvider,
  });

  @override
  State<PrivacyWidget> createState() => _PrivacyWidgetState();
}

class _PrivacyWidgetState extends State<PrivacyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Column(
        children: [
          privacyTitle(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade800.withOpacity(1),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        deleteAccount(),
                        exportData(),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget deleteAccount() {
    return Row(
      children: [
        const Icon(Icons.delete_forever, size: 18),
        const SizedBox(
          width: 4,
        ),
        Text(
          AppLocalizations.of(context)!.accountRemoval_text_privacyWidget,
          style: const TextStyle(fontSize: 15),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
            text: AppLocalizations.of(context)!
                .deleteMyAccount_richText_privacyWidget,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeleteAccountPage(
                      currentUser: widget.currentUser,
                      userAuthProvider: widget.userAuthProvider,
                    ),
                  ),
                ).then((didUserPressDeleteAccountButton) async {
                  if (didUserPressDeleteAccountButton == true) {
                    await showDialog(
                      context: context,
                      builder: (context) => SuccessfulMessageDialog(
                        sucessMessage: AppLocalizations.of(context)!
                            .deleteAccountCountdownCanceled_text_privacyWidgetDeleteAccountPage,
                      ),
                    );
                  }
                });
              },
          ),
        ),
      ],
    );
  }

  Widget exportData() {
    return Row(
      children: [
        const Icon(Icons.download, size: 18),
        const SizedBox(
          width: 4,
        ),
        Text(
          AppLocalizations.of(context)!.myDataExport_text_privacyWidget,
          style: const TextStyle(fontSize: 15),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
            text: AppLocalizations.of(context)!
                .downloadMyData_richText_privacyWidget,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExportDataPage(
                      notesTextList: widget.notesTextList,
                      notesTasksList: widget.notesTasksList,
                      folders: widget.folders,
                      currentUser: widget.currentUser,
                    ),
                  ),
                );
              },
          ),
        ),
      ],
    );
  }

  Widget privacyTitle() {
    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.privacyTitle_text_accountSecurityPrivacy,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}
