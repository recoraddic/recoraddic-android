// models/third_page_content.dart
import 'package:hive/hive.dart';
import 'record.dart';
import 'goal.dart';

part 'third_page_content.g.dart';

@HiveType(typeId: 2)
class ThirdPageContent extends HiveObject {
  @HiveField(0)
  final List<Record> recordList;

  @HiveField(1)
  final List<Goal> goalList;

  @HiveField(2)
  final int blockColor;

  ThirdPageContent({
    required this.recordList,
    required this.goalList,
    required this.blockColor,
  });
}
