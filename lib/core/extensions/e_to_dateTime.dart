extension ParseDateExtension on String {
  DateTime toDate() {
    List<String> parts = this.split('/');
    if (parts.length != 3) {
      throw FormatException('Invalid date format');
    }

    int month = int.parse(parts[0]);
    int day = int.parse(parts[1]);
    int year = int.parse(parts[2]);

    return DateTime(year, month, day);
  }
}
