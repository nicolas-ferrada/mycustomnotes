import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycustomnotes/data/models/User/user_configuration.dart';

import '../../domain/services/auth_user_service.dart';
import '../../domain/services/user_configuration_service.dart';
import '../enums/last_modification_date_formats_enum.dart';

// Formatter from firebase to a readable form
class DateFormatter {
  static String showLastModificationDateFormatted({
    required Timestamp lastModificationDate,
    required UserConfiguration userConfiguration,
    required BuildContext context,
  }) {
    // This variable will take the final date ready to be returned depending on the conditions.
    late String finalDate;

    // Get the user configuration of date time format
    String dateFormat = userConfiguration.dateTimeFormat;

    // Transform the firestore Timestamp to DateTime
    final DateTime lastModificationDateToDateTime =
        lastModificationDate.toDate();

    // If the last note modification was today, this year or another year
    final WhenItWasLastModification whenItWasTheLastModification =
        whenItWasTheLastNoteModification(
            date: lastModificationDateToDateTime, context: context);

    finalDate = getFinalDate(
      whenWasLastMod: whenItWasTheLastModification,
      dateFormat: dateFormat,
      lastModificationDateTime: lastModificationDateToDateTime,
    );
    return finalDate;
  }

  static String getFinalDate({
    required WhenItWasLastModification whenWasLastMod,
    required String dateFormat,
    required DateTime lastModificationDateTime,
  }) {
    late String finalDate;

    // 24 hours - day/month/year
    if (dateFormat ==
        LastModificationDateFormat.dayMonthYear.value +
            LastModificationTimeFormat.hours24.value) {
      // Last modification was today
      if (whenWasLastMod == WhenItWasLastModification.today) {
        finalDate = DateFormat('Hm').format(lastModificationDateTime);
        return finalDate;
        // Last modification was this year
      } else if (whenWasLastMod == WhenItWasLastModification.thisYear) {
        finalDate = DateFormat('d MMM').format(lastModificationDateTime);
        return finalDate;
        // Last modification was another year
      } else if (whenWasLastMod == WhenItWasLastModification.anotherYear) {}
      finalDate = DateFormat('y').format(lastModificationDateTime);
      return finalDate;
    }
    // 24 hours - year/month/day
    if (dateFormat ==
        LastModificationDateFormat.yearMonthDay.value +
            LastModificationTimeFormat.hours24.value) {
      // Last modification was today
      if (whenWasLastMod == WhenItWasLastModification.today) {
        finalDate = DateFormat('Hm').format(lastModificationDateTime);
        return finalDate;
        // Last modification was this year
      } else if (whenWasLastMod == WhenItWasLastModification.thisYear) {
        finalDate = DateFormat('MMM d').format(lastModificationDateTime);
        return finalDate;
        // Last modification was another year
      } else if (whenWasLastMod == WhenItWasLastModification.anotherYear) {}
      finalDate = DateFormat('y').format(lastModificationDateTime);
      return finalDate;
    }

    // 24 hours - month/day/year
    if (dateFormat ==
        LastModificationDateFormat.monthDayYear.value +
            LastModificationTimeFormat.hours24.value) {
      // Last modification was today
      if (whenWasLastMod == WhenItWasLastModification.today) {
        finalDate = DateFormat('Hm').format(lastModificationDateTime);
        return finalDate;
        // Last modification was this year
      } else if (whenWasLastMod == WhenItWasLastModification.thisYear) {
        finalDate = DateFormat('MMM d').format(lastModificationDateTime);
        return finalDate;
        // Last modification was another year
      } else if (whenWasLastMod == WhenItWasLastModification.anotherYear) {}
      finalDate = DateFormat('y').format(lastModificationDateTime);
      return finalDate;
    }

    // 12 hours - day/month/year
    if (dateFormat ==
        LastModificationDateFormat.dayMonthYear.value +
            LastModificationTimeFormat.hours12.value) {
      // Last modification was today
      if (whenWasLastMod == WhenItWasLastModification.today) {
        finalDate = DateFormat('jm').format(lastModificationDateTime);
        return finalDate;
        // Last modification was this year
      } else if (whenWasLastMod == WhenItWasLastModification.thisYear) {
        finalDate = DateFormat('d MMM').format(lastModificationDateTime);
        return finalDate;
        // Last modification was another year
      } else if (whenWasLastMod == WhenItWasLastModification.anotherYear) {}
      finalDate = DateFormat('y').format(lastModificationDateTime);
      return finalDate;
    }

    // 12 hours - year/month/day
    if (dateFormat ==
        LastModificationDateFormat.yearMonthDay.value +
            LastModificationTimeFormat.hours12.value) {
      // Last modification was today
      if (whenWasLastMod == WhenItWasLastModification.today) {
        finalDate = DateFormat('jm').format(lastModificationDateTime);
        return finalDate;
        // Last modification was this year
      } else if (whenWasLastMod == WhenItWasLastModification.thisYear) {
        finalDate = DateFormat('MMM d').format(lastModificationDateTime);
        return finalDate;
        // Last modification was another year
      } else if (whenWasLastMod == WhenItWasLastModification.anotherYear) {}
      finalDate = DateFormat('y').format(lastModificationDateTime);
      return finalDate;
    }

    // 12 hours - month/day/year
    if (dateFormat ==
        LastModificationDateFormat.monthDayYear.value +
            LastModificationTimeFormat.hours12.value) {
      // Last modification was today
      if (whenWasLastMod == WhenItWasLastModification.today) {
        finalDate = DateFormat('jm').format(lastModificationDateTime);
        return finalDate;
        // Last modification was this year
      } else if (whenWasLastMod == WhenItWasLastModification.thisYear) {
        finalDate = DateFormat('MMM d').format(lastModificationDateTime);
        return finalDate;
        // Last modification was another year
      } else if (whenWasLastMod == WhenItWasLastModification.anotherYear) {}
      finalDate = DateFormat('y').format(lastModificationDateTime);
      return finalDate;
    }

    return 'Error: Format not found';
  }

  static WhenItWasLastModification whenItWasTheLastNoteModification({
    required DateTime date,
    required BuildContext context,
  }) {
    final today = DateTime.now();

    // Formatted date if last modification was today
    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      return WhenItWasLastModification.today;
      // Formatted date if the date is from the current year
    } else if (date.year == DateTime.now().year) {
      return WhenItWasLastModification.thisYear;
    } else {
      // If is not today and not this year, show the year of the note.
      return WhenItWasLastModification.anotherYear;
    }
  }

  static Future<String> showDateFormattedAllFields({
    required Timestamp dateDB,
    required BuildContext context,
  }) async {
    final User currentUser = AuthUserService.getCurrentUserFirebase();

    late UserConfiguration userConfiguration;

    // get user configuration
    userConfiguration = await UserConfigurationService.getUserConfigurations(
        context: context, userId: currentUser.uid);

    late String formattedTime;

    final DateTime date = dateDB.toDate();
    // Get the user configuration of date time format
    String dateFormat = userConfiguration.dateTimeFormat;

    // 24 hours - day/month/year
    if (dateFormat ==
        LastModificationDateFormat.dayMonthYear.value +
            LastModificationTimeFormat.hours24.value) {
      formattedTime =
          DateFormat('d MMMM y ').format(date) + DateFormat.Hm().format(date);
      return formattedTime;
    }

    // 24 hours - month/day/year
    if (dateFormat ==
        LastModificationDateFormat.monthDayYear.value +
            LastModificationTimeFormat.hours24.value) {
      formattedTime =
          DateFormat('MMMM d y ').format(date) + DateFormat.Hm().format(date);
      return formattedTime;
    }

    // 24 hours - year/month/day
    if (dateFormat ==
        LastModificationDateFormat.yearMonthDay.value +
            LastModificationTimeFormat.hours24.value) {
      formattedTime =
          DateFormat('y MMMM d ').format(date) + DateFormat.Hm().format(date);
      return formattedTime;
    }

    // 12 hours - day/month/year
    if (dateFormat ==
        LastModificationDateFormat.dayMonthYear.value +
            LastModificationTimeFormat.hours12.value) {
      formattedTime =
          DateFormat('d MMMM y ').format(date) + DateFormat.jm().format(date);
      return formattedTime;
    }

    // 12 hours - year/month/day
    if (dateFormat ==
        LastModificationDateFormat.yearMonthDay.value +
            LastModificationTimeFormat.hours12.value) {
      formattedTime =
          DateFormat('y MMMM d ').format(date) + DateFormat.jm().format(date);
      return formattedTime;
    }

    // 12 hours - month/day/year
    if (dateFormat ==
        LastModificationDateFormat.monthDayYear.value +
            LastModificationTimeFormat.hours12.value) {
      formattedTime =
          DateFormat('MMMM d y ').format(date) + DateFormat.jm().format(date);
      return formattedTime;
    }

    return 'Error: Format not found';
  }
}

// formattedTime =
//           '$formattedDay $monthName ${dateTimeFromDatabase.year} $formattedHour:$formattedMinutes';
