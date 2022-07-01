import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'habit_data.g.dart';

var uuid = const Uuid();

@HiveType(typeId: 3)
class HabitData {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime generateDate;

  @HiveField(3)
  int targetCount;

  HabitData({String? id, required this.name, required this.generateDate, required this.targetCount})
  : id = id ?? uuid.v4() ;
}