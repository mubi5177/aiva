extension DateParsing on String {
  DateTime toDate() {
    // Split the dateString into day, month, and year components
    List<String> dateParts = this.split(' ');
    int day = int.parse(dateParts[0]);

    // Map month names to their numeric values
    Map<String, int> monthMap = {
      'January': 1, 'February': 2, 'March': 3, 'April': 4, 'May': 5, 'June': 6,
      'July': 7, 'August': 8, 'September': 9, 'October': 10, 'November': 11, 'December': 12
    };

    int? month = monthMap[dateParts[1]];
    int year = int.parse(dateParts[2]);

    // Create a DateTime object from the parsed components
    return DateTime(year, month!, day);
  }
}