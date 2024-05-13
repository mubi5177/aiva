import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get timeAgo {
    final difference = DateTime.now().difference(this);
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds}s';
    } else {
      return 'just now';
    }
  }

  String format({String format = "'at' hh:mm a"}) {
    return DateFormat.yMMMMd().addPattern(format).format(this);
  }

  String formatDateTime({String format = 'MM/dd/yyyy hh:mm a'}) {
    return DateFormat(format).format(this);
  }

  String formatTime({String format = 'MMMM'}) {
    return DateFormat(format).format(this);
  }

  String yearMonthFormat({String format = 'yyyy-MM'}) {
    return DateFormat.yMMMM().format(this);
  }

  String formatDuration(Duration duration) {
    String daysStr = duration.inDays == 1 ? 'day' : 'days';
    String hoursStr = duration.inHours.remainder(24).toString();
    String minutesStr = duration.inMinutes.remainder(60).toString();

    return '${duration.inDays} $daysStr, $hoursStr hours, $minutesStr minutes';
  }

  String timeFormat({String format = 'mm'}) {
    return DateFormat(format).format(this);
  }
}
