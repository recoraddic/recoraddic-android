import 'package:hive/hive.dart';

part 'quest.g.dart';

@HiveType(typeId: 0)
class Quest extends HiveObject {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  bool isDone = false;

  Quest({
    required this.name,
    required this.isDone,
  });
}
