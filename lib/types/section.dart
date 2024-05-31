// types/section_record.dart
import 'package:hive/hive.dart';

part 'section.g.dart';

@HiveType(typeId: 3)
class Section extends HiveObject {
  @HiveField(0)
  DateTime startDate;

  @HiveField(1)
  DateTime endDate;

  @HiveField(2)
  List<String> goalList;

  @HiveField(3)
  int blockColor;

  Section({
    required this.startDate,
    required this.endDate,
    required this.goalList,
    required this.blockColor,
  });

  Section copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? goalList,
    int? blockColor,
  }) {
    return Section(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      goalList: goalList ?? this.goalList,
      blockColor: blockColor ?? this.blockColor,
    );
  }
}