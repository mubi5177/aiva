import 'package:intl/intl.dart';

extension ParseDateTime on String {
  DateTime toDateTime({String format = "MM/dd/yyyy hh:mm a"}) {
    DateFormat dateFormat = DateFormat(format);
    return dateFormat.parse(this);
  }
}