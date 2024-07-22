extension DateFormatExtension on String {
  String get formatDate {
    // Parse the original date string into a DateTime object
    DateTime dateTime = DateTime.parse(this);

    // Format the DateTime object into "MM/DD/YYYY" format
    String formatted = "${dateTime.month.toString().padLeft(2, '0')}/"
        "${dateTime.day.toString().padLeft(2, '0')}/"
        "${dateTime.year.toString()}";

    return formatted;
  }
}