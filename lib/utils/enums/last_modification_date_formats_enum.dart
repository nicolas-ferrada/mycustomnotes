enum LastModificationDateFormat {
  dayMonthYear('DD/MM/YYYY'),
  yearMonthDay('YYYY/MM/DD'),
  monthDayYear('MM/DD/YYYY');

  const LastModificationDateFormat(this.date);
  final String date;
}

enum LastModificationTimeFormat {
  hours12('12hrs'),
  hours24('24hrs');

  const LastModificationTimeFormat(this.time);
  final String time;
}

enum WhenItWasLastModification {
  today,
  thisYear,
  anotherYear,
}
