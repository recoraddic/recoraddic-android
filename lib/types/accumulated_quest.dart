// models/record.dart
import 'package:hive/hive.dart';
import 'package:recoraddic/first_page/function/calendarfunc.dart';
import 'package:recoraddic/types/quest.dart';
import 'package:recoraddic/first_page/function/calendarfunc.dart';
part 'accumulated_quest.g.dart';

@HiveType(typeId: 2)
class AccumulatedQuest extends HiveObject {
  @HiveField(0)
  Quest quest = Quest(name: '', isDone: false);

  @HiveField(1)
  List<DateTime> dates = [];

  @HiveField(2)
  int tier = 0;

  @HiveField(3)
  int momentumLevel = 0;

  AccumulatedQuest({
    required this.quest
  });

  void update() {
    calculateTier();
    this.momentumLevel = returnMomentumLevel();
  }

  void calculateTier() {
    var cumulative = dates.length;
    for (var i = 0; i <= 40; i++) {
      var minus = 0;
      if (i >= 0 && i <= 9) {
        minus = 1;
      } else if (i >= 10 && i <= 14) {
        minus = 6;
      } else if (i >= 15 && i <= 19) {
        minus = 12;
      } else if (i >= 20 && i <= 24) {
        minus = 60;
      } else if (i >= 25 && i <= 29) {
        minus = 120;
      } else if (i >= 30 && i <= 34) {
        minus = 600;
      } else if (i >= 35 && i <= 39) {
        minus = 1200;
      } else {
        minus = -9999999;
      }

      if (cumulative - minus < 0 || i == 40) {
        this.tier = i;
        break;
      } else {
        cumulative -= minus;
      }
    }
  }

  void updateMomentumLevel() {
      this.momentumLevel = returnMomentumLevel();
  }


  int returnMomentumLevel() {
    var today = normalize(DateTime.now());

    if (dates.length == 0) {
      return 0;
    }

    // var latestRecordDate = dates.reduce((a, b) => a.isBefore(b) ? b : a);
    // var unactivatedPeriod = (latestRecordDate, today);

    if (checkMomentumLevel(0.299, 50, today)) {
      return 10;
    } else if (checkMomentumLevel(0.299, 40, today)) {
      return 9;
    } else if (checkMomentumLevel(0.332, 30, today)) {
      return 8;
    } else if (checkMomentumLevel(0.399, 20, today)) {
      return 7;
    } else if (checkMomentumLevel(0.428, 14, today)) {
      return 6;
    } else if (checkMomentumLevel(0.499, 10, today)) {
      return 5;
    } else if (checkMomentumLevel(0.570, 7, today)) {
      return 4;
    } else if (checkMomentumLevel(0.599, 5, today)) {
      return 3;
    } else if (checkMomentumLevel(0.666, 3, today)) {
      return 2;
    } else if (checkMomentumLevel(1.0, 1, today)) {
      return 1;
    } else {
      return 0;
    }
  }

  bool checkMomentumLevel(double ratio, int termLength, DateTime today) {
    var baseDate = today.subtract(Duration(days: termLength));

    var numberOfRecordedDates = dates.where((date) => date.difference(baseDate).inDays + 1  > 0).length;

    return ratio <= numberOfRecordedDates / termLength;
  }
}





