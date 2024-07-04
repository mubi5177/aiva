import 'package:intl/intl.dart';

extension DateParsing on String {
  String formatDateString() {
    // Split the dateString into day, month, and year components
    List<String> dateParts = this.split('/');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    // Create a DateTime object from the parsed components
    var date = DateTime(year, month, day);

    // Format the date using DateFormat from intl package
    return DateFormat('dd MMMM yyyy', 'en_US').format(date);
  }
}

