// models/record.dart
import 'package:hive/hive.dart';
import 'package:recoraddic/types/quest.dart';

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
}
