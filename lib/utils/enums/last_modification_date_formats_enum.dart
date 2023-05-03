enum LastModificationDateFormat {
  dayMonthYear('DD/MM/YYYY'),
  yearMonthDay('YYYY/MM/DD'),
  monthDayYear('MM/DD/YYYY');

  const LastModificationDateFormat(this.value);
  final String value;
}

enum LastModificationTimeFormat {
  hours12('12hrs'),
  hours24('24hrs');

  const LastModificationTimeFormat(this.value);
  final String value;
}

enum WhenItWasLastModification {
  today,
  thisYear,
  anotherYear,
}
