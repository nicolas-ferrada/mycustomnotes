import 'package:cloud_firestore/cloud_firestore.dart';

class DateFormatter {
// Formate the timestamp from firebase to a user friendly date
// Day, Month, Year, Hour, Minutes
  static String showDateFormatted(Timestamp lastModificationDate) {
    final DateTime dateTime = lastModificationDate.toDate();
    //final String formattedTime = DateFormat('d-M-y H:m').format(dateTime);

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    final String formattedTime = '$day-$month-${dateTime.year} $hour:$minute';

    return formattedTime;
  }
}
