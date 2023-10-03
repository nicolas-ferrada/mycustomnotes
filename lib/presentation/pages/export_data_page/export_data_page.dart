import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:mycustomnotes/utils/dialogs/successful_message_dialog.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/models/Note/folder_model.dart';
import '../../../data/models/Note/note_tasks_model.dart';
import '../../../data/models/Note/note_text_model.dart';

import '../../../l10n/l10n_export.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';
import 'export_data_page_create_sheets_functions/export_data_page_create_folder_sheet.dart';
import 'export_data_page_create_sheets_functions/export_data_page_create_note_tasks_sheet.dart';
import 'export_data_page_create_sheets_functions/export_data_page_create_note_text_sheet.dart';
import 'export_data_page_create_sheets_functions/export_data_page_user_sheet.dart';

import 'package:shared_storage/shared_storage.dart' as saf;

class ExportDataPage extends StatefulWidget {
  final List<NoteText> notesTextList;
  final List<NoteTasks> notesTasksList;
  final List<Folder> folders;
  final User currentUser;
  const ExportDataPage({
    super.key,
    required this.notesTextList,
    required this.notesTasksList,
    required this.folders,
    required this.currentUser,
  });

  @override
  State<ExportDataPage> createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!
              .exportDataTitle_text_privacyWidgetExportDataPage,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  AppLocalizations.of(context)!
                      .exportDataSubtitle_text_privacyWidgetExportDataPage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Platform.isAndroid
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        AppLocalizations.of(context)!
                            .exportDataSubtitle2_text_privacyWidgetExportDataPage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  AppLocalizations.of(context)!
                      .exportDataSubtitle3_text_privacyWidgetExportDataPage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  AppLocalizations.of(context)!
                      .exportDataSubtitle4_text_privacyWidgetExportDataPage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  minimumSize: const Size(200, 60),
                  backgroundColor: Colors.white,
                ),
                onPressed: () async {
                  try {
                    if (Platform.isAndroid) {
                      exportDataForAndroid(context);
                    } else if (Platform.isIOS) {
                      exportDataForIOS();
                    } else {
                      throw Exception('Invalid platform');
                    }
                  } catch (errorMessage) {
                    if (!context.mounted) return;
                    ExceptionsAlertDialog.showErrorDialog(
                      context: context,
                      errorMessage: errorMessage.toString(),
                    );
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!
                      .exportDataTitle_text_privacyWidgetExportDataPage,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void exportDataForAndroid(BuildContext context) async {
    final Uri path = await getPathAndPermissionsAndroid();

    String fileName = 'MyCustomNotes-${widget.currentUser.uid}.xlsx';

    Excel excel = createExcelData();

    final List<int>? excelBytes = excel.encode();

    if (excelBytes == null) {
      if (!context.mounted) return;
      throw Exception(
        AppLocalizations.of(context)!
            .exportDataFileCouldNotBeCreated_exception_privacyWidgetExportDataPage,
      ).removeExceptionWord;
    }

    saf.DocumentFile? createdFile = await saf.createFileAsBytes(
      path,
      mimeType:
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      displayName: fileName,
      bytes: Uint8List.fromList(excelBytes),
    );

    if (createdFile == null) {
      if (!context.mounted) return;
      throw Exception(
        AppLocalizations.of(context)!
            .exportDataFileCouldNotBeCreated_exception_privacyWidgetExportDataPage,
      ).removeExceptionWord;
    }

    if (!context.mounted) return;
    Navigator.maybePop(context).then(
      (_) => showDialog(
        context: context,
        builder: (context) => SuccessfulMessageDialog(
          sucessMessage: AppLocalizations.of(context)!
              .exportDataSucessfulExportation_dialog_privacyWidgetExportDataPage,
        ),
      ),
    );
  }

  Future<Uri> getPathAndPermissionsAndroid() async {
    final Uri? grantedUri = await saf.openDocumentTree(
      grantWritePermission: true,
    );

    if (grantedUri == null) {
      if (!context.mounted) return throw Exception('Permission not granted');
      throw Exception(
        AppLocalizations.of(context)!
            .exportDataPermissionDenied_exception_privacyWidgetExportDataPage,
      ).removeExceptionWord;
    }

    if (await saf.canWrite(grantedUri) ?? false) {
      return grantedUri;
    } else {
      if (!context.mounted) return throw Exception('Permission not granted');
      throw Exception(
        AppLocalizations.of(context)!
            .exportDataPermissionDenied_exception_privacyWidgetExportDataPage,
      ).removeExceptionWord;
    }
  }

  void exportDataForIOS() async {
    await getPermissionIOS();
    Directory downloadPath = await getApplicationDocumentsDirectory();
    String finalpath =
        '${downloadPath.path}/MyCustomNotes-${widget.currentUser.uid}.xlsx';
    Excel excel = createExcelData();
    String? operationResult = saveExcelToFile(excel: excel, path: finalpath);

    if (operationResult != null &&
        operationResult == 'Success' &&
        context.mounted) {
      Navigator.maybePop(context).then(
        (_) => showDialog(
          context: context,
          builder: (context) => SuccessfulMessageDialog(
            sucessMessage: AppLocalizations.of(context)!
                .exportDataSucessfulExportationIOS_dialog_privacyWidgetExportDataPage,
          ),
        ),
      );
    } else {
      if (!context.mounted) return;
      throw Exception(
        AppLocalizations.of(context)!
            .exportDataGenericException_exception_privacyWidgetExportDataPage,
      );
    }
  }

  Future<void> getPermissionIOS() async {
    PermissionStatus status = await Permission.storage.request();
    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        if (context.mounted) {
          throw Exception(
            AppLocalizations.of(context)!
                .exportDataPermissionPermanentlyDenied_exception_privacyWidgetExportDataPage,
          ).removeExceptionWord;
        }
      } else {
        if (context.mounted) {
          throw Exception(
            AppLocalizations.of(context)!
                .exportDataPermissionDenied_exception_privacyWidgetExportDataPage,
          ).removeExceptionWord;
        }
      }
    }
  }

  Future<String> getDownloadFolderPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path.toString();
  }

  String? saveExcelToFile({
    required Excel excel,
    required String path,
  }) {
    String? operationResult;
    final excelBytes = excel.encode();
    if (excelBytes != null) {
      File(join(path))
        ..createSync(recursive: true)
        ..writeAsBytesSync(excelBytes);
      operationResult = 'Success';
    } else {
      if (context.mounted) {
        throw Exception(
          AppLocalizations.of(context)!
              .exportDataFileCouldNotBeCreated_exception_privacyWidgetExportDataPage,
        ).removeExceptionWord;
      }
    }
    return operationResult;
  }

  Excel createExcelData() {
    Excel excel = Excel.createExcel();

    excel = ExportDataPageUserSheet.createUserSheet(
      currentUser: widget.currentUser,
      excel: excel,
    );

    if (widget.notesTextList.isNotEmpty) {
      excel = ExportDataPageCreateNoteTextSheet.createNoteTextSheet(
        notes: widget.notesTextList,
        excel: excel,
      );
    }

    if (widget.notesTextList.isNotEmpty) {
      excel = ExportDataPageCreateNoteTextSheet.createNoteTextSheet(
        notes: widget.notesTextList,
        excel: excel,
      );
    }
    if (widget.notesTasksList.isNotEmpty) {
      excel = ExportDataPageCreateNoteTasksSheet.createNoteTasksSheet(
        notes: widget.notesTasksList,
        excel: excel,
      );
    }
    if (widget.folders.isNotEmpty) {
      excel = ExportDataPageCreateFolderSheet.createFolderSheet(
        folders: widget.folders,
        excel: excel,
      );
    }

    excel.delete('Sheet1'); // removes the sheet created by the library

    return excel;
  }
}
