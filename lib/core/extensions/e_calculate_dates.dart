// extension DateRangeExtension on DateTime {
//   List<DateTime> datesUntil(DateTime endDate) {
//     List<DateTime> dates = [];
//     DateTime currentDate = this;
//
//     while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
//       dates.add(currentDate);
//       currentDate = currentDate.add(const Duration(days: 1));
//     }
//
//     return dates;
//   }
// }


extension DateTimeExtension on DateTime {
  List<DateTime> datesUntilWithTime(DateTime endDate) {
    List<DateTime> dates = [];
    DateTime currentDate = this;

    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    return dates;
  }
}