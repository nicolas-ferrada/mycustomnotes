import 'package:flutter/material.dart';
import 'package:mycustomnotes/utils/app_color_scheme/app_color_scheme.dart';
import '../../../l10n/l10n_export.dart';
import '../../styles/dialog_title_style.dart';

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

  String getUserCurrentSelectedView({
    required UserConfiguration userConfiguration,
    required BuildContext context,
  }) {
    String userDateTimeFormat = userConfiguration.dateTimeFormat;

    switch (userDateTimeFormat) {
      // 12 HRS
      case 'DD/MM/YYYY12hrs':
        return AppLocalizations.of(context)!
            .dayMonthYear12hoursCurrentFormatSelected_drawerDialog_homePage;
      case 'YYYY/MM/DD12hrs':
        return AppLocalizations.of(context)!
            .yearMonthDay12hoursCurrentFormatSelected_drawerDialog_homePage;
      case 'MM/DD/YYYY12hrs':
        return AppLocalizations.of(context)!
            .monthDayYear12hoursCurrentFormatSelected_drawerDialog_homePage;
      // 24 HRS
      case 'DD/MM/YYYY24hrs':
        return AppLocalizations.of(context)!
            .dayMonthYear24hoursCurrentFormatSelected_drawerDialog_homePage;
      case 'YYYY/MM/DD24hrs':
        return AppLocalizations.of(context)!
            .yearMonthDay24hoursCurrentFormatSelected_drawerDialog_homePage;
      case 'MM/DD/YYYY24hrs':
        return AppLocalizations.of(context)!
            .monthDayYear24hoursCurrentFormatSelected_drawerDialog_homePage;
      default:
        return AppLocalizations.of(context)!.unexpectedException_dialog;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 3,
          backgroundColor: Colors.grey.shade400,
          title: DialogTitleStyle(
            title: AppLocalizations.of(context)!
                .dateTimeTitle_drawerDialog_homePage,
          ),
          content: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
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
                              ? AppColorScheme.purple()
                              : Colors.grey.shade800.withOpacity(0.9),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              setState(() {
                                userSelectedDateFormat =
                                    LastModificationDateFormat
                                        .dayMonthYear.value;
                                selectedDateCard = 1;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 4),
                                const Icon(
                                  Icons.calendar_today,
                                  size: 38,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .dayMonthYearOption_drawerDialog_homePage,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
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
                              ? AppColorScheme.purple()
                              : Colors.grey.shade800.withOpacity(0.9),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              setState(() {
                                userSelectedDateFormat =
                                    LastModificationDateFormat
                                        .yearMonthDay.value;
                                selectedDateCard = 2;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 4),
                                const Icon(
                                  Icons.calendar_month,
                                  size: 38,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .yearMonthDayOption_drawerDialog_homePage,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
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
                              ? AppColorScheme.purple()
                              : Colors.grey.shade800.withOpacity(0.9),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              setState(() {
                                userSelectedDateFormat =
                                    LastModificationDateFormat
                                        .monthDayYear.value;
                                selectedDateCard = 3;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 4),
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 38,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .monthDayYearOption_drawerDialog_homePage,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
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
                              ? AppColorScheme.purple()
                              : Colors.grey.shade800.withOpacity(0.9),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              setState(() {
                                userSelectedTimeFormat =
                                    LastModificationTimeFormat.hours12.value;
                                selectedTimeCard = 1;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 4),
                                const Icon(
                                  Icons.access_time_filled,
                                  size: 38,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .hours12option_drawerDialog_homePage,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
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
                              ? AppColorScheme.purple()
                              : Colors.grey.shade800.withOpacity(0.9),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              setState(() {
                                userSelectedTimeFormat =
                                    LastModificationTimeFormat.hours24.value;
                                selectedTimeCard = 2;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 4),
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 38,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .hours24option_drawerDialog_homePage,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
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
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(0.8),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Center(
                          child: Text(
                            '${AppLocalizations.of(context)!.currentFormatSelectedInfo_drawerDialog_homePage}${getUserCurrentSelectedView(userConfiguration: widget.userConfiguration, context: context)}',
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
                        backgroundColor: Colors.white),
                    onPressed: () {
                      if (userSelectedDateFormat != null &&
                          userSelectedTimeFormat != null) {
                        userFinalSelectedTimeDateFormat =
                            userSelectedDateFormat! + userSelectedTimeFormat!;
                        Navigator.maybePop(
                            context, userFinalSelectedTimeDateFormat);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .applyChanges_button_drawerDialog_homePage,
                      style: const TextStyle(
                        color: Colors.black,
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
                        backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.cancelButton,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
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
