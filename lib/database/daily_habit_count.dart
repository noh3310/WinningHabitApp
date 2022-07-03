import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'daily_habit_count.g.dart';

var _uuid = const Uuid();

@HiveType(typeId: 1)
class DailyHabitCount {
  @HiveField(0)
  String id;

  @HiveField(1)
  String habitTypeId;

  @HiveField(2)
  DateTime habitCountDate;

  @HiveField(3)
  int count;

  DailyHabitCount({String? id, required this.habitCountDate, required this.habitTypeId, int? count})
      : count = count ?? 1, id = id ?? _uuid.v4();
}
