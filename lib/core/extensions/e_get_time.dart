import 'package:flutter/material.dart';

extension TimeParser on String {
  TimeOfDay parseTimeOfDay() {
    String time = this.trim(); // Remove leading and trailing whitespace

    // Split the string by ":"
    List<String> parts = time.split(':');

    // Extract hours (part before ":")
    int hours = int.parse(parts[0].trim());

    // Extract minutes (part between ":" and "am" or "pm")
    // Remove any non-digit characters from the minutes part
    String minutesPart = parts[1].replaceAll(RegExp(r'[^0-9]'), '');
    int minutes = int.parse(minutesPart);

    // Determine if it's AM or PM based on the original string
    bool isAM = time.toLowerCase().contains('am');

    // Adjust hours for PM times (assuming non-military time)
    if (!isAM && hours < 12) {
      hours += 12;
    }

    return TimeOfDay(hour: hours, minute: minutes);
  }
}
