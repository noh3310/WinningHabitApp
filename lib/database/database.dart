import 'package:hive/hive.dart';

import 'package:hive/hive.dart';
import 'package:winning_habit/database/habit_data.dart';

class DatabaseManager {

  late Box<HabitData> box;

  // 초기화
  Future<void> init() async {
    box = await Hive.openBox('habitData');
  }

  // 습관 추가
  Future<bool> addHabit(String? name, int? count) async {
    if (name == null || count == null) {
      return false;
    }
    final _habit = HabitData(name: name, generateDate: DateTime.now(), targetCount: count);
    await box.put(_habit.id, _habit);
    return true;
  }
}