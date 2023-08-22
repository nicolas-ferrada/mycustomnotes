import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

class ExportDataPageUserSheet {
  static Excel createUserSheet({
    required Excel excel,
    required User currentUser,
  }) {
    Sheet sheet = excel['user'];

    sheet.cell(CellIndex.indexByString("A1")).value = "id";
    sheet.cell(CellIndex.indexByString("B1")).value = "email";
    sheet.cell(CellIndex.indexByString("C1")).value = "creation_date";

    sheet.cell(CellIndex.indexByString("A2")).value = currentUser.uid;
    sheet.cell(CellIndex.indexByString("B2")).value = currentUser.email;
    sheet.cell(CellIndex.indexByString("C2")).value =
        currentUser.metadata.creationTime.toString();

    return excel;
  }
}
