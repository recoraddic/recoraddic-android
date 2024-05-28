// models/record.dart
import 'package:hive/hive.dart';
import 'package:recoraddic/types/quest.dart';

part 'accumulated_quest.g.dart';

@HiveType(typeId: 2)
class AccumulatedQuest extends HiveObject {
  @HiveField(0)
  Quest quest = Quest(quest: '', isDone: false);

  @HiveField(1)
  int count = 0;

  AccumulatedQuest({
    required this.quest,
    required this.count,
  });
}
