import 'package:cloud_firestore/cloud_firestore.dart';

class DateFormatter {
// Formate the timestamp from firebase to a user friendly date
// Day, Month, Year, Hour, Minutes
  static String showDateFormatted(Timestamp lastModificationDate) {
    final DateTime dateTimeFromDatabase = lastModificationDate.toDate();
    String monthName = DateFormatter.getMonthName(dateTimeFromDatabase);
    final today = DateTime.now();
    late String formattedTime;
    String formattedHour = dateTimeFromDatabase.hour.toString().padLeft(2, '0');
    String formattedMinutes =
        dateTimeFromDatabase.minute.toString().padLeft(2, '0');
    String formattedDay = dateTimeFromDatabase.day.toString().padLeft(2, '0');

    // Formatted date if the day is today
    if (dateTimeFromDatabase.day == today.day &&
        dateTimeFromDatabase.month == today.month &&
        dateTimeFromDatabase.year == today.year) {
      formattedTime = '$formattedHour:$formattedMinutes';
      // Formatted date if the date is from the current year
    } else if (dateTimeFromDatabase.year == DateTime.now().year) {
      formattedTime = '$formattedDay $monthName';
    } else {
      // If is not today and not this year, show the year of the note.
      formattedTime = '$formattedDay $monthName ${dateTimeFromDatabase.year}';
    }
    return formattedTime;
  }

  // Get the month of the note in
  static String getMonthName(DateTime date) {
    // final spanishMonth = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    final englishMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final index = date.month - 1;
    return englishMonths[index];
  }
}
