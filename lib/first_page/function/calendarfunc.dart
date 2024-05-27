
import 'package:intl/intl.dart';

DateTime normalize(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

List<List<DateTime>> partitionByWeek(DateTime startDate, DateTime endDate) {
  List<List<DateTime>> result = [];
  List<DateTime> currentWeek = [];
  DateTime currentDate = startDate;

  while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
    int weekOfYear = weekNumber(currentDate);
    int weekOfYearNextDay = weekNumber(currentDate.add(const Duration(days: 1)));

    currentWeek.add(currentDate);

    if (weekOfYear != weekOfYearNextDay) {
      result.add(currentWeek);
      currentWeek = [];
    }

    currentDate = currentDate.add(const Duration(days: 1));
  }

  if (currentWeek.isNotEmpty) {
    result.add(currentWeek);
  }

  return result;
}

// int weekNumber(DateTime date) {
//   int dayOfYear = int.parse(DateFormat('D').format(date));
//   int weekday = date.weekday == DateTime.sunday ? 0 : date.weekday - 1;
//   return ((dayOfYear - weekday + 10) / 7).floor();
// }

int weekNumber(DateTime date) {
  final dayOfYear = int.parse(DateFormat('D').format(date));
  final weekday = date.weekday != DateTime.sunday ? date.weekday - 1 : 6;
  final week = ((dayOfYear - weekday + 9) / 7).floor();

  if (week < 1) {
    // Last week of previous year.
    final lastDayOfLastYear = DateTime(date.year - 1, 12, 31);
    return weekNumber(lastDayOfLastYear);
  } else if (week > 51 && date.month == 1) {
    // First week of next year.
    return 1;
  } else {
    return week;
  }
}