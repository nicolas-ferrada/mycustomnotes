import 'package:excel/excel.dart';
import 'package:mycustomnotes/utils/extensions/color_to_hex.dart';

import '../../../../data/models/Note/folder_model.dart';
import '../../../../utils/extensions/compare_booleans.dart';
import '../../../../utils/note_color/note_color.dart';

class ExportDataPageCreateFolderSheet {
  static Excel createFolderSheet({
    required Excel excel,
    required List<Folder> folders,
  }) {
    Sheet sheet = excel['folders'];

    sheet.cell(CellIndex.indexByString("A1")).value = "id";
    sheet.cell(CellIndex.indexByString("B1")).value = "name";
    sheet.cell(CellIndex.indexByString("C1")).value = "stored_note_text_id";
    sheet.cell(CellIndex.indexByString("D1")).value = "stored_note_tasks_id";
    sheet.cell(CellIndex.indexByString("E1")).value = "creation_date";
    sheet.cell(CellIndex.indexByString("F1")).value = "is_favorite";
    sheet.cell(CellIndex.indexByString("G1")).value = "color";

    for (var i = 0; i < folders.length; i++) {
      // Order folders by date and favorite.
      folders.sort((a, b) => a.createdDate.compareTo(b.createdDate));
      folders.sort((a, b) =>
          CompareBooleans.compareBooleans(a.isFavorite, b.isFavorite));

      Folder folder = folders[i];
      int row = i + 2;

      sheet.cell(CellIndex.indexByString("A$row")).value = folder.id;
      sheet.cell(CellIndex.indexByString("B$row")).value = folder.name;
      sheet.cell(CellIndex.indexByString("C$row")).value =
          folder.storedNoteTextIdField.toString();
      sheet.cell(CellIndex.indexByString("D$row")).value =
          folder.storedNoteTasksIdField.toString();
      sheet.cell(CellIndex.indexByString("E$row")).value =
          folder.createdDate.toDate().toString();
      sheet.cell(CellIndex.indexByString("F$row")).value =
          folder.isFavorite.toString();
      sheet.cell(CellIndex.indexByString("G$row")).value =
          NoteColorOperations.getColorFromNumber(colorNumber: folder.color)
              .toHex();
    }

    return excel;
  }
}
