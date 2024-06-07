// models/record.dart
import 'package:hive/hive.dart';
import 'package:recoraddic/types/quest.dart';

part 'daily_record.g.dart';

@HiveType(typeId: 1)
class DailyRecord extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String diary = '';

  @HiveField(2)
  List<DailyQuest> dailyQuestList_accumulated = [];

  @HiveField(3)
  List<DailyQuest> dailyQuestList_normal = [];

  @HiveField(4)
  int facialExpressionIndex = -1;

  @HiveField(5)
  bool isSaved = false;

  DailyRecord({
    required this.date,
    required this.diary,
    required this.dailyQuestList_accumulated,
    required this.dailyQuestList_normal,
    required this.facialExpressionIndex,
    required this.isSaved,
  });
}
