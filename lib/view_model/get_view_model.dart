import 'package:get/get.dart';
import 'package:winning_habit/database/database.dart';

import '../database/habit_data.dart';

enum HabitAchieveState { add, minus }

class GetViewModel extends GetxController {
  Rx<DateTime> dateTime = DateTime.now().obs;

  RxList<HabitData> notAchieveHabitList = <HabitData>[].obs;
  RxList<HabitData> achieveHabitList = <HabitData>[].obs;

  final DatabaseManager _databaseManager = DatabaseManager();

  // Private한 생성자 생성
  GetViewModel._privateConstructor() {
    // 날짜 선택하면 습관정보 업데이트
    dateTime.listen((date) {
      updateHabitList(date);
    });

    // 초기값 설정(오늘 날짜로 설정)
    updateHabitList(DateTime.now());
  }

  // 생성자를 호출하고 반환된 Singleton 인스턴스를 _instance 변수에 할당
  static final GetViewModel _instance = GetViewModel._privateConstructor();

  // Singleton() 호출시에 _instance 변수를 반환
  factory GetViewModel() {
    return _instance;
  }

  void updateDate(DateTime newDate) {
    final startTime = DateTime(newDate.year, newDate.month, newDate.day);
    dateTime.value = startTime;
  }

  void updateHabitList(DateTime dateTime) {
    final startTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    notAchieveHabitList.value =
        _databaseManager.getNotAchieveHabitList(startTime);
    achieveHabitList.value = _databaseManager.getAchieveHabitList(startTime);
  }

  HabitData getHabitData(int section, int item) {
    return section == 0 ? notAchieveHabitList[item] : achieveHabitList[item];
  }

  int getCount(int achieveState) {
    return achieveState == 0
        ? notAchieveHabitList.length
        : achieveHabitList.length;
  }

  // MARK: Database
  String getCountString(HabitData habitData) {
    return _databaseManager.getDateHabitCount(habitData, dateTime.value);
  }

  Future<bool> habitAchievement(
      HabitData habitData, HabitAchieveState state) async {
    // 오늘 날짜인지 확인
    final today = DateTime.now();
    final startDate = DateTime(today.year, today.month, today.day);
    final startDateTime =
        DateTime(dateTime.value.year, dateTime.value.month, dateTime.value.day);
    if (startDateTime.compareTo(startDate) == 0) {
      if (state == HabitAchieveState.minus) {
        await _databaseManager.minusDailyHabit(habitData);
      } else {
        await _databaseManager.addDailyHabit(habitData);
      }
      updateHabitList(dateTime.value);

      return true;
    }
    return false;
  }
}