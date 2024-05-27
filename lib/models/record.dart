// models/record.dart
import 'package:hive/hive.dart';

part 'record.g.dart';

@HiveType(typeId: 0)
class Record extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  String diary;

  @HiveField(2)
  List<String> accumulatedQuest;

  @HiveField(3)
  List<String> normalQuest;

  @HiveField(4)
  int facialExpressionIndex;

  Record({
    required this.date,
    required this.diary,
    required this.accumulatedQuest,
    required this.normalQuest,
    required this.facialExpressionIndex,
  });
}