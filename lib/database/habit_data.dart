import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'habit_data.g.dart';

var _uuid = const Uuid();

@HiveType(typeId: 0)
class HabitData {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime generateDate;

  @HiveField(3)
  int targetCount;

  @HiveField(4)
  int color;

  HabitData({String? id, required this.name, required this.generateDate, required this.targetCount, required this.color})
  : id = id ?? _uuid.v4() ;
}