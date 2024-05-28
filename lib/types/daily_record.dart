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
  List<Quest> accumulatedQuestList = [];

  @HiveField(3)
  List<Quest> normalQuestList = [];

  @HiveField(4)
  int facialExpressionIndex = -1;

  @HiveField(5)
  bool isSaved = false;

  DailyRecord({
    required this.date,
    required this.diary,
    required this.accumulatedQuestList,
    required this.normalQuestList,
    required this.facialExpressionIndex,
    required this.isSaved,
  });
}
