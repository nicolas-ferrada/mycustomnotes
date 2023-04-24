import 'package:flutter/material.dart';

import '../../../data/models/User/user_configuration.dart';
import '../../enums/last_modification_date_formats_enum.dart';

class ChangeNoteDateTimeFormat extends StatefulWidget {
  final BuildContext context;
  final UserConfiguration userConfiguration;
  const ChangeNoteDateTimeFormat({
    super.key,
    required this.context,
    required this.userConfiguration,
  });

  @override
  State<ChangeNoteDateTimeFormat> createState() =>
      _ChangeNoteDateTimeFormatState();
}

class _ChangeNoteDateTimeFormatState extends State<ChangeNoteDateTimeFormat> {
  String? userFinalSelectedTimeDateFormat;
  String? userSelectedDateFormat;
  String? userSelectedTimeFormat;

  // -1 none, 1, 2 and 3 for date and 1 and 2 for time, left to right.
  late int selectedDateCard;
  late int selectedTimeCard;

  @override
  void initState() {
    super.initState();
    userSelectedDateFormat =
        getDate(userConfiguration: widget.userConfiguration);
    userSelectedTimeFormat =
        getTime(userConfiguration: widget.userConfiguration);

    if (userSelectedDateFormat != null) {
      selectedDateCard = getCurrentDateIndex(date: userSelectedDateFormat!);
    } else {
      selectedDateCard = 0;
    }
    if (userSelectedTimeFormat != null) {
      selectedTimeCard = getCurrentTimeIndex(time: userSelectedTimeFormat!);
    } else {
      selectedTimeCard = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: const Color.fromRGBO(250, 216, 90, 0.8),
          title: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.grey.shade800.withOpacity(0.9),
              child: const Text(
                'Date and time\n format',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dates
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Card(
                        elevation: 10,
                        color: (selectedDateCard == 1)
                            ? Colors.red
                            : Colors.grey.shade800.withOpacity(0.9),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            setState(() {
                              userSelectedDateFormat =
                                  LastModificationDateFormat.dayMonthYear.date;
                              selectedDateCard = 1;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 4),
                              Icon(
                                Icons.calendar_today,
                                size: 38,
                                color: Colors.white,
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Day\nMonth\nYear',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Card(
                        elevation: 10,
                        color: (selectedDateCard == 2)
                            ? Colors.red
                            : Colors.grey.shade800.withOpacity(0.9),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            setState(() {
                              userSelectedDateFormat =
                                  LastModificationDateFormat.yearMonthDay.date;
                              selectedDateCard = 2;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 4),
                              Icon(
                                Icons.calendar_month,
                                size: 38,
                                color: Colors.white,
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Year\nMonth\nDay',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Card(
                        elevation: 10,
                        color: (selectedDateCard == 3)
                            ? Colors.red
                            : Colors.grey.shade800.withOpacity(0.9),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            setState(() {
                              userSelectedDateFormat =
                                  LastModificationDateFormat.monthDayYear.date;
                              selectedDateCard = 3;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 4),
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 38,
                                color: Colors.white,
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Month\nDay\nYear',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey.shade800.withOpacity(0.9),
                ),
                // Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Card(
                        elevation: 10,
                        color: (selectedTimeCard == 1)
                            ? Colors.red
                            : Colors.grey.shade800.withOpacity(0.9),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            setState(() {
                              userSelectedTimeFormat =
                                  LastModificationTimeFormat.hours12.time;
                              selectedTimeCard = 1;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 4),
                              Icon(
                                Icons.access_time_filled,
                                size: 38,
                                color: Colors.white,
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  '12 hours',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Card(
                        elevation: 10,
                        color: (selectedTimeCard == 2)
                            ? Colors.red
                            : Colors.grey.shade800.withOpacity(0.9),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            setState(() {
                              userSelectedTimeFormat =
                                  LastModificationTimeFormat.hours24.time;
                              selectedTimeCard = 2;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 4),
                              Icon(
                                Icons.access_time_rounded,
                                size: 38,
                                color: Colors.white,
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  '24 hours',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      color: Colors.grey.shade800.withOpacity(0.9),
                      child: Center(
                        child: Text(
                          'Current format selected:\n${getUserCurrentSelectedView(userConfiguration: widget.userConfiguration)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  // Apply changes
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.grey.shade800.withOpacity(0.9)),
                    onPressed: () {
                      if (userSelectedDateFormat != null &&
                          userSelectedTimeFormat != null) {
                        userFinalSelectedTimeDateFormat =
                            userSelectedDateFormat! + userSelectedTimeFormat!;
                        Navigator.maybePop(
                            context, userFinalSelectedTimeDateFormat);
                      }
                    },
                    child: const Text(
                      'Apply changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Close button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.grey.shade800.withOpacity(0.9)),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String getUserCurrentSelectedView({
    required UserConfiguration userConfiguration,
  }) {
    String userDateTimeFormat = userConfiguration.dateTimeFormat;

    switch (userDateTimeFormat) {
      // 12 HRS
      case 'DD/MM/YYYY12hrs':
        return 'Day/Month/Year 12 hours';
      case 'YYYY/MM/DD12hrs':
        return 'Year/Month/Day 12 hours';
      case 'MM/DD/YYYY12hrs':
        return 'Month/Day/Year 12 hours';
      // 24 HRS
      case 'DD/MM/YYYY24hrs':
        return 'Day/Month/Year 24 hours';
      case 'YYYY/MM/DD24hrs':
        return 'Year/Month/Day 24 hours';
      case 'MM/DD/YYYY24hrs':
        return 'Month/Day/Year 24 hours';
      default:
        return 'No format selected found...';
    }
  }

  String? getDate({
    required UserConfiguration userConfiguration,
  }) {
    String userDateTimeFormat = userConfiguration.dateTimeFormat;

    switch (userDateTimeFormat) {
      // 12 HRS
      case 'DD/MM/YYYY12hrs':
        return 'DD/MM/YYYY';
      case 'YYYY/MM/DD12hrs':
        return 'YYYY/MM/DD';
      case 'MM/DD/YYYY12hrs':
        return 'MM/DD/YYYY';
      // 24 HRS
      case 'DD/MM/YYYY24hrs':
        return 'DD/MM/YYYY';
      case 'YYYY/MM/DD24hrs':
        return 'YYYY/MM/DD';
      case 'MM/DD/YYYY24hrs':
        return 'MM/DD/YYYY';
      default:
        return null;
    }
  }

  String? getTime({
    required UserConfiguration userConfiguration,
  }) {
    String userDateTimeFormat = userConfiguration.dateTimeFormat;

    switch (userDateTimeFormat) {
      // 12 HRS
      case 'DD/MM/YYYY12hrs':
        return '12hrs';
      case 'YYYY/MM/DD12hrs':
        return '12hrs';
      case 'MM/DD/YYYY12hrs':
        return '12hrs';
      // 24 HRS
      case 'DD/MM/YYYY24hrs':
        return '24hrs';
      case 'YYYY/MM/DD24hrs':
        return '24hrs';
      case 'MM/DD/YYYY24hrs':
        return '24hrs';
      default:
        return null;
    }
  }

  int getCurrentDateIndex({
    required String date,
  }) {
    String userDateTimeFormat = date;

    switch (userDateTimeFormat) {
      case 'DD/MM/YYYY':
        return 1;
      case 'YYYY/MM/DD':
        return 2;
      case 'MM/DD/YYYY':
        return 3;
      default:
        return 0;
    }
  }

  int getCurrentTimeIndex({
    required String time,
  }) {
    String userDateTimeFormat = time;

    switch (userDateTimeFormat) {
      case '12hrs':
        return 1;
      case '24hrs':
        return 2;
      default:
        return 0;
    }
  }
}
