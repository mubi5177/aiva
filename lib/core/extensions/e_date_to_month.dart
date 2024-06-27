import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toMonthYearString() {
    return DateFormat.yMMMM().format(this);
  }
}
