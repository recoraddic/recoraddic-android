import 'package:hive/hive.dart';

part 'quest.g.dart';

@HiveType(typeId: 0)
class Quest extends HiveObject {
  @HiveField(0)
  String quest = '';

  @HiveField(1)
  bool isDone = false;

  Quest({
    required this.quest,
    required this.isDone,
  });
}
