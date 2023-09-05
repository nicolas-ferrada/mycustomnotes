import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import '../../../data/models/Note/folder_notifier.dart';
import '../../../data/models/User/user_configuration.dart';
import '../../../domain/services/auth_services.dart/auth_user_service.dart';
import '../../../utils/dialogs/delete_folder_confirmation.dart';
import 'package:provider/provider.dart';

import '../../../data/models/Note/folder_model.dart';
import '../../../data/models/Note/note_tasks_model.dart';
import '../../../data/models/Note/note_text_model.dart';
import '../../../domain/services/folder_service.dart';
import '../../../l10n/l10n_export.dart';
import '../../../utils/dialogs/confirmation_dialog.dart';
import '../../../utils/dialogs/folder_details_info.dart';
import '../../../utils/dialogs/note_pick_color_dialog.dart';
import '../../../utils/enums/menu_item_note_detail.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../../utils/internet/check_internet_connection.dart';
import '../../../utils/note_color/note_color.dart';
import '../../../utils/snackbars/snackbar_message.dart';
import '../home_page/home_page_widgets/home_page_build_notes_folders_widget.dart';

class FolderDetailsPage extends StatefulWidget {
  final Folder? folder; // If no folder is given, then user is creating one
  final List<NoteText>? noteTextList;
  final List<NoteTasks>? noteTasksList;
  final UserConfiguration userConfiguration;
  final bool? editingFromSearchBar; // if true, call navigator.pop twice
  final Function? updateVariablesInPreviousPage;

  const FolderDetailsPage({
    super.key,
    this.folder,
    this.noteTextList,
    this.noteTasksList,
    required this.userConfiguration,
    this.editingFromSearchBar,
    this.updateVariablesInPreviousPage,
  });

  @override
  State<FolderDetailsPage> createState() => _FolderDetailsPageState();
}

class _FolderDetailsPageState extends State<FolderDetailsPage> {
  // Variables that change to finally be saved
  int color = 0;
  Color noteColorPaletteIcon = Colors.grey;
  bool isFavorite = false;
  String name = '';
  late Timestamp createdDate;

  bool? didTitleChanged = false;
  bool? didBodyChanged = false;
  bool? didColorChanged = false;
  bool? didFavoriteChanged = false;
  bool? didUrlChanged = false;
  bool? didSelectedNoteChanged = false;

  bool wasTheSaveButtonPressed = false;

  bool isFolderInEditMode =
      true; // if folder is not null, it'll be changed to false in initstate

  // Variable is updated by the child (build_notes_folders_widget)
  List<NoteText> selectedNoteText = [];
  List<NoteTasks> selectedNoteTasks = [];

  final User currentUser = AuthUserService.getCurrentUser();

  void selectedNoteChanged() {
    setState(() {
      didSelectedNoteChanged = true;
    });
  }

  void updateSelectedNoteText(
    List<NoteText> incomingSelectedNoteText,
  ) {
    setState(() {
      selectedNoteText = incomingSelectedNoteText;
    });
  }

  void updateSelectedNoteTasks(
    List<NoteTasks> incomingSelectedNoteTasks,
  ) {
    setState(() {
      selectedNoteTasks = incomingSelectedNoteTasks;
    });
  }

  List<String> getNoteTextIds() {
    return selectedNoteText.map((note) => note.id).toList();
  }

  List<String> getNoteTasksIds() {
    return selectedNoteTasks.map((note) => note.id).toList();
  }

  bool didUserMadeChanges() {
    bool didUserMadeChanges = (didTitleChanged ?? false) ||
        (didFavoriteChanged ?? false) ||
        (didColorChanged ?? false) ||
        (didBodyChanged ?? false) ||
        (didUrlChanged ?? false) ||
        (didSelectedNoteChanged ?? false);
    return didUserMadeChanges;
  }

  void updateVariables() {
    if (widget.folder != null) {
      setState(() {
        color = widget.folder!.color;
        noteColorPaletteIcon =
            NoteColorOperations.getColorFromNumber(colorNumber: color);
        isFavorite = widget.folder!.isFavorite;
        name = widget.folder!.name;
        createdDate = widget.folder!.createdDate;
      });
      isFolderInEditMode = false;
    }
  }

  @override
  void initState() {
    super.initState();
    updateVariables();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        if (didUserMadeChanges() == true && wasTheSaveButtonPressed == false) {
          final bool? shouldPop =
              await ConfirmationDialog.discardChangesNoteDetails(context);
          return shouldPop ?? false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            widget.folder != null ? menuEdit() : menuCreate(),
          ],
          // Folder's title
          title: TextFormField(
            initialValue: name,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (newNameChanged) {
              // Changes are being made
              if (newNameChanged != widget.folder?.name) {
                setState(() {
                  didTitleChanged = true;
                });
                name = newNameChanged.trim();
                // No changes
              } else {
                setState(() {
                  didTitleChanged = false;
                });
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context)!
                  .folderTitle_textformfield_folder,
              hintStyle: const TextStyle(color: Colors.white70),
            ),
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: HomePageBuildNotesAndFoldersWidget(
          notesTasksList: widget.noteTasksList ?? [],
          notesTextList: widget.noteTextList ?? [],
          userConfiguration: widget.userConfiguration,
          areNotesBeingEdited: isFolderInEditMode,
          updateSelectedNoteText: updateSelectedNoteText,
          updateSelectedNoteTasks: updateSelectedNoteTasks,
          currentFolder: widget.folder,
          didSelectedNoteChanged: selectedNoteChanged,
          editingFromSearchBar: false,
        ),

        // Save button, only visible if user changes the note
        floatingActionButton: saveButton(context),
      ),
    );
  }

  Widget saveButton(BuildContext context) {
    return Visibility(
      visible: didUserMadeChanges(),
      child: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromRGBO(250, 216, 90, 0.9),
        child: const Icon(Icons.save),
        onPressed: () async {
          if (widget.folder != null) {
            editingFolder();
          } else {
            creatingFolder();
          }
        },
      ),
    );
  }

  editingFolder() async {
    try {
      wasTheSaveButtonPressed = true;

      // Check if device it's connected to any network
      bool isDeviceConnected =
          await CheckInternetConnection.checkInternetConnection();
      int waitingToConnect = 5;

      // If device is connected, wait 5 seconds, if is not connected, dont wait.
      if (isDeviceConnected) {
        waitingToConnect = 5;
      } else {
        waitingToConnect = 0;
      }
      if (context.mounted) {
        Folder newFolder = Folder(
          id: widget.folder!.id,
          userId: widget.folder!.userId,
          createdDate: widget.folder!.createdDate,
          name: name,
          color: color,
          isFavorite: isFavorite,
          storedNoteTasksIdField: getNoteTasksIds(),
          storedNoteTextIdField: getNoteTextIds(),
        );
        await FolderService.editFolder(
          folder: newFolder,
          context: context,
        ).timeout(
          Duration(seconds: waitingToConnect),
          onTimeout: () {
            saveEditingFolder();
          },
        );
      }

      if (context.mounted) {
        saveEditingFolder();
      }
    } catch (errorMessage) {
      ExceptionsAlertDialog.showErrorDialog(
          context: context, errorMessage: errorMessage.toString());
    }
  }

  creatingFolder() async {
    try {
      wasTheSaveButtonPressed = true;

      // Check if device it's connected to any network
      bool isDeviceConnected =
          await CheckInternetConnection.checkInternetConnection();
      int waitingToConnectiong = 5;

      // If device is connected, wait 5 seconds, if is not connected, dont wait.
      if (isDeviceConnected) {
        waitingToConnectiong = 5;
      } else {
        waitingToConnectiong = 0;
      }
      if (context.mounted) {
        Folder newFolder = Folder(
          id: '', // id will be provided in the service class
          userId: currentUser.uid,
          name: name,
          color: color,
          isFavorite: isFavorite,
          createdDate: Timestamp.now(),
          storedNoteTasksIdField: getNoteTasksIds(),
          storedNoteTextIdField: getNoteTextIds(),
        );
        await FolderService.createFolder(
          folder: newFolder,
          context: context,
        ).timeout(
          Duration(seconds: waitingToConnectiong),
          onTimeout: () {
            saveCreatingFolder();
          },
        );
      }

      if (context.mounted) {
        saveCreatingFolder();
      }
    } catch (errorMessage) {
      ExceptionsAlertDialog.showErrorDialog(
          context: context, errorMessage: errorMessage.toString());
    }
  }

  void saveEditingFolder() {
    Provider.of<FolderNotifier>(context, listen: false).refreshFolders();
    // Double navigator.pop when editing from search bar to avoid not updating bug
    if (widget.editingFromSearchBar != null &&
        widget.editingFromSearchBar == true) {
      Navigator.maybePop(context).then((_) => Navigator.maybePop(context));
    } else {
      Navigator.maybePop(context);
    }
  }

  void saveCreatingFolder() {
    Provider.of<FolderNotifier>(context, listen: false).refreshFolders();
    Navigator.maybePop(context).then((_) => Navigator.maybePop(context));
  }

  Widget menuCreate() {
    return Row(
      children: [
        // Favorite
        IconButton(
          onPressed: () async {
            pickColor();
          },
          icon: Icon(
            Icons.palette,
            color: noteColorPaletteIcon,
            size: 28,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.star,
            color: isFavorite ? Colors.amberAccent : Colors.grey,
            size: 28,
          ),
          onPressed: () {
            markAsFavorite();
          },
        ),
      ],
    );
  }

  // Menu note button (icon three dots)
  PopupMenuButton menuEdit() {
    return PopupMenuButton(
      onSelected: (value) async {
        if (value == MenuItemNoteDetail.item1) {
          // Edit folder
          editFolder();
        } else if (value == MenuItemNoteDetail.item2) {
          // Mark as favorite
          markAsFavorite();
        } else if (value == MenuItemNoteDetail.item3) {
          // Pick color palette
          pickColor();
        } else if (value == MenuItemNoteDetail.item5) {
          // Details
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return FolderDetailsInfo(
                  context: context, folder: widget.folder!);
            },
          );
        } else if (value == MenuItemNoteDetail.item6) {
          // Delete
          try {
            DeleteFolderConfirmation.deleteFolderDialog(
                context: context, folder: widget.folder!);
          } catch (errorMessage) {
            await ExceptionsAlertDialog.showErrorDialog(
                context: context, errorMessage: errorMessage.toString());
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: MenuItemNoteDetail.item1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.edit,
                color: isFolderInEditMode ? Colors.redAccent : Colors.white,
                size: 28,
              ),
              Text(AppLocalizations.of(context)!
                  .folderFunctionsMenu_popupMenu_edit)
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.star,
                color: isFavorite ? Colors.amberAccent : Colors.white,
                size: 28,
              ),
              Text(AppLocalizations.of(context)!
                  .noteFunctionsMenu_popupMenu_favorite),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item3,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.palette,
                size: 28,
                color: noteColorPaletteIcon,
              ),
              Text(AppLocalizations.of(context)!
                  .noteFunctionsMenu_popupMenu_color),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item5,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.info, size: 28),
              Text(AppLocalizations.of(context)!
                  .noteFunctionsMenu_popupMenu_details),
            ],
          ),
        ),
        PopupMenuItem(
          value: MenuItemNoteDetail.item6,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.delete, size: 28),
              Text(AppLocalizations.of(context)!
                  .noteFunctionsMenu_popupMenu_delete),
            ],
          ),
        ),
      ],
    );
  }

  // Join edit mode in folder
  void editFolder() {
    if (!isFolderInEditMode) {
      setState(() {
        isFolderInEditMode = true;
      });
    } else {
      setState(() {
        isFolderInEditMode = false;
      });
    }
  }

  // PopupButton favorite
  void markAsFavorite() {
    if (widget.folder != null) {
      if (!isFavorite) {
        isFavorite = true;
        // Now it's favorite, if it was favorite from the start, then user did not make any changes
        if (widget.folder!.isFavorite) {
          SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
            message: AppLocalizations.of(context)!
                .favorite_snackbar_folderMarkedAgain,
            backgroundColor: Colors.amber.shade300,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
          setState(() {
            didFavoriteChanged = false;
          });
          // Now it's favorite, but it wasn't from the start, so user made a change
        } else {
          SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
            message:
                AppLocalizations.of(context)!.favorite_snackbar_folderMarked,
            backgroundColor: Colors.amber.shade300,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
          setState(() {
            didFavoriteChanged = true;
          });
        }
      } else {
        // It's favorite, so change it to not favorite
        isFavorite = false;
        // Note now it's not favorite, if it was favorite from the start, then user did make a change
        if (widget.folder!.isFavorite) {
          SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
            message:
                AppLocalizations.of(context)!.favorite_snackbar_folderUnmarked,
            backgroundColor: Colors.grey,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
          setState(() {
            didFavoriteChanged = true;
          });
          // Note now it's not favorite, if it was favorite from the start, then user did not make any changes
        } else {
          SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
            message: AppLocalizations.of(context)!
                .favorite_snackbar_folderUnmarkedAgain,
            backgroundColor: Colors.grey,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
          setState(() {
            didFavoriteChanged = false;
          });
        }
      }
    } else {
      // No folder was given, so user is creating one
      setState(() {
        if (!isFavorite) {
          setState(() {
            isFavorite = true;
            didFavoriteChanged = true;
          });
          SnackBar snackBarIsFavorite = SnackBarMessage.snackBarMessage(
            message:
                AppLocalizations.of(context)!.favorite_snackbar_folderMarked,
            backgroundColor: Colors.amber.shade300,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBarIsFavorite);
        } else {
          setState(() {
            isFavorite = false;
            didFavoriteChanged = false;
          });
        }
      });
    }
  }

  pickColor() async {
    if (widget.folder != null) {
      // Get the note color picked by the user, if no color is picked, keeps the original color
      late Color colorPickedByUser;
      NoteColor? getColorFromDialog = await showDialog<NoteColor?>(
        context: context,
        builder: (context) {
          return const NotePickColorDialog();
        },
      );
      if (getColorFromDialog != null) {
        colorPickedByUser = getColorFromDialog.getColor;
      } else {
        colorPickedByUser = NoteColorOperations.getColorFromNumber(
            colorNumber: widget.folder!.color);
      }
      color = NoteColorOperations.getNumberFromColor(color: colorPickedByUser);
      // If the colors picked by user is not the same as the current notes color, send message
      if (color != widget.folder!.color) {
        // Shows a snackbar with the background color selected by user
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarMessage.snackBarMessage(
                message: AppLocalizations.of(context)!
                    .color_snackbar_newColorSelected,
                backgroundColor: colorPickedByUser),
          );
        }
        setState(() {
          // Changes the color of the icon to the new one
          noteColorPaletteIcon = colorPickedByUser;
          // Show the save button
          didColorChanged = true;
        });
      } else {
        // User picked the same color
        setState(() {
          // Changes the color of the icon to the current note color
          didColorChanged = false;
          noteColorPaletteIcon = colorPickedByUser;
          // if not null, user picked the same color, if is null, it means user did not pick any color, so dont show the snackbar
          if (getColorFromDialog != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBarMessage.snackBarMessage(
                  message: AppLocalizations.of(context)!
                      .color_snackbar_folderAlreadyHaveThisColor,
                  backgroundColor: colorPickedByUser),
            );
          }
        });
      }
    } else {
      // No folder is given, so user is creating one
      late Color newColor;
      NoteColor? getColorFromDialog = await showDialog<NoteColor?>(
        context: context,
        builder: (context) {
          return const NotePickColorDialog();
        },
      );
      if (getColorFromDialog != null) {
        newColor = getColorFromDialog.getColor;
        didColorChanged = true;
      } else {
        newColor = NoteColorOperations.getColorFromNumber(colorNumber: color);
      }
      // Difine the note color
      color = NoteColorOperations.getNumberFromColor(color: newColor);
      setState(() {
        noteColorPaletteIcon = newColor;
      });
    }
  }
}
