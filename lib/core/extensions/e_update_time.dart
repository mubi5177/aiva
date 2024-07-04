import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  /// Updates the time part of the current DateTime object based on a new time string.
  DateTime updateTime(String newTime) {
    // Parse the new time string into a TimeOfDay object
    List<String> timeParts = newTime.split(':');
    TimeOfDay newTimeOfDay = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
      // Assuming the newTime string always includes seconds if needed.
      // second: int.parse(timeParts.length > 2 ? timeParts[2] : '0'),
    );

    // Update the time part of the original DateTime
    return DateTime(
      this.year,
      this.month,
      this.day,
      newTimeOfDay.hour,
      newTimeOfDay.minute,
      // You can optionally add seconds and milliseconds if needed
      // second,
      // millisecond,
      // microsecond,
    );
  }
}