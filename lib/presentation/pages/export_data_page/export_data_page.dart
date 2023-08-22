import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:mycustomnotes/utils/dialogs/successful_message_dialog.dart';
import 'package:mycustomnotes/utils/extensions/formatted_message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
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
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  AppLocalizations.of(context)!
                      .exportDataSubtitle2_text_privacyWidgetExportDataPage,
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
                    // Get permissions to save the file
                    await getManageExteralStoragePermission();

                    String downloadFolderPath = await getDownloadFolderPath();

                    // File include UID to avoid two users in the same phone to delete their file
                    String finalPath =
                        '$downloadFolderPath/MyCustomNotes-${widget.currentUser.uid}.xlsx';

                    Excel excel = createExcelData();

                    // Save the excel in the given folder (download)
                    String? operationResult =
                        saveExcelToFile(excel: excel, path: finalPath);

                    if (operationResult != null &&
                        operationResult == 'Success' &&
                        context.mounted) {
                      Navigator.maybePop(context).then(
                        (_) => showDialog(
                          context: context,
                          builder: (context) => SuccessfulMessageDialog(
                            sucessMessage: AppLocalizations.of(context)!
                                .exportDataSucessfulExportation_dialog_privacyWidgetExportDataPage,
                          ),
                        ),
                      );
                    } else {
                      throw Exception(
                        AppLocalizations.of(context)!
                            .exportDataGenericException_exception_privacyWidgetExportDataPage,
                      );
                    }
                  } catch (errorMessage) {
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

  Future<void> getManageExteralStoragePermission() async {
    // Get permission of 'all files' to save the exported file in the download folder.

    late PermissionStatus status;
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if ((info.version.sdkInt) >= 33) {
        // Android 13 or more
        status = await Permission.manageExternalStorage.request();
      } else {
        // Lower than android 13
        status = await Permission.storage.request();
      }
    } else {
      // For IOS
      status = await Permission.storage.request();
    }
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
    late String directory;
    if (Platform.isIOS) {
      directory = (await getDownloadsDirectory())!.path;
    } else {
      directory = "/storage/emulated/0/Download";
      bool dirDownloadExists = await Directory(directory).exists();
      if (!dirDownloadExists) {
        directory = "/storage/emulated/0/Downloads";
      }
    }
    return directory;
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
}
