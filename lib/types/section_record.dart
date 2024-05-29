// models/record.dart
import 'package:hive/hive.dart';

part 'section_record.g.dart';

@HiveType(typeId: 3)
class SectionRecord extends HiveObject {
  @HiveField(0)
  DateTime startDate;

  @HiveField(1)
  DateTime endDate;

  @HiveField(2)
  List<String> goalList;

  @HiveField(3)
  int blockColor;

  SectionRecord({
    required this.startDate,
    required this.endDate,
    required this.goalList,
    required this.blockColor,
  });
}