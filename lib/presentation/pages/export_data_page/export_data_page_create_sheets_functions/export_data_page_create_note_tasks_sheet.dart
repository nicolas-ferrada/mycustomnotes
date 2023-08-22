import 'package:excel/excel.dart';
import 'package:mycustomnotes/utils/extensions/color_to_hex.dart';

import '../../../../data/models/Note/note_tasks_model.dart';
import '../../../../utils/extensions/compare_booleans.dart';
import '../../../../utils/note_color/note_color.dart';

class ExportDataPageCreateNoteTasksSheet {
  static Excel createNoteTasksSheet({
    required Excel excel,
    required List<NoteTasks> notes,
  }) {
    Sheet sheet = excel['tasks_notes'];

    sheet.cell(CellIndex.indexByString("A1")).value = "id";
    sheet.cell(CellIndex.indexByString("B1")).value = "title";
    sheet.cell(CellIndex.indexByString("C1")).value = "tasks";
    sheet.cell(CellIndex.indexByString("D1")).value = "creation_date";
    sheet.cell(CellIndex.indexByString("E1")).value = "last_modification_date";
    sheet.cell(CellIndex.indexByString("F1")).value = "is_favorite";
    sheet.cell(CellIndex.indexByString("G1")).value = "color";

    for (var i = 0; i < notes.length; i++) {
      // Order notes by date and favorite.
      notes.sort((a, b) => a.createdDate.compareTo(b.createdDate));
      notes.sort((a, b) =>
          CompareBooleans.compareBooleans(a.isFavorite, b.isFavorite));

      NoteTasks note = notes[i];
      int row = i + 2;

      sheet.cell(CellIndex.indexByString("A$row")).value = note.id;
      sheet.cell(CellIndex.indexByString("B$row")).value = note.title;
      sheet.cell(CellIndex.indexByString("C$row")).value =
          note.tasks.toString();
      sheet.cell(CellIndex.indexByString("D$row")).value =
          note.createdDate.toDate().toString();
      sheet.cell(CellIndex.indexByString("E$row")).value =
          note.lastModificationDate.toDate().toString();
      sheet.cell(CellIndex.indexByString("F$row")).value =
          note.isFavorite.toString();
      sheet.cell(CellIndex.indexByString("G$row")).value =
          NoteColorOperations.getColorFromNumber(colorNumber: note.color)
              .toHex();
    }

    return excel;
  }
}
