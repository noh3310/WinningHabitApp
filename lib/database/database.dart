import 'package:hive_flutter/hive_flutter.dart';
import 'package:winning_habit/database/daily_habit_count.dart';
import 'package:winning_habit/database/habit_data.dart';
import 'package:uuid/uuid.dart';

const _dataHabitString = 'dataHabit';
const _dailyHabitCountString = 'dailyHabitCount';

class DatabaseManager {
  // Private한 생성자 생성
  DatabaseManager._privateConstructor();

  // 생성자를 호출하고 반환된 Singleton 인스턴스를 _instance 변수에 할당
  static final DatabaseManager instance = DatabaseManager._privateConstructor();

  // Singleton() 호출시에 _instance 변수를 반환
  factory DatabaseManager() {
    return instance;
  }

  late Box<HabitData>? _habitData;
  late Box<DailyHabitCount>? _dailyHabitCount;

  // 초기화
  Future<void> init() async {
    await Hive.initFlutter();
    // Hive에서는 typeId를 변경하면 안된다 만약 변경하려면 아래 코드를 작성한 후 Adapter를 등록해야한다.
    Hive.ignoreTypeId<HabitData>(3);
    // 생성된 어댑터를 등록해준다.
    Hive.registerAdapter(HabitDataAdapter());
    Hive.registerAdapter(DailyHabitCountAdapter());
    // // 제네릭을 선언해 habitData에는 Habitdata만 담을 수 있도록 설정
    await Hive.openBox<HabitData>(_dataHabitString);
    await Hive.openBox<DailyHabitCount>(_dailyHabitCountString);
    _habitData = await Hive.openBox(_dataHabitString);
    _dailyHabitCount = await Hive.openBox(_dailyHabitCountString);
    // _dailyHabitCount?.deleteFromDisk();
    // _habitData?.deleteFromDisk();
  }

  // 습관 추가
  Future<void> addHabit(String name, int count) async {
    DateTime toTime = DateTime.now();
    DateTime startTime = DateTime(toTime.year, toTime.month, toTime.day);

    var habit =
        HabitData(name: name, generateDate: startTime, targetCount: count);
    // key값이 잘못 들어갈 수 있으므로 중복되는 값이 있다면 key를 새로 발급
    while (true) {
      final temp = _habitData?.get(habit.id);
      if (temp == null) {
        break;
      } else {
        final uuid = Uuid();
        // 새로 발급
        habit.id = uuid.v4();
      }
    }
    await _habitData?.put(habit.id, habit);

    _habitData?.values.toList().forEach((element) {
      print(element.id);
      print(element.name);
      print(element.targetCount);
      print(element.generateDate);
    });
  }

  // 데일리 습관달성 데이터베이스 추가
  Future<void> addDailyHabit(HabitData habitData) async {
    DateTime toTime = DateTime.now();
    DateTime startTime = DateTime(toTime.year, toTime.month, toTime.day);

    // 오늘 생성한 습관이 있는지 확인
    var results = _dailyHabitCount?.values
        .toList()
        .where((element) => element.habitTypeId == habitData.id)
        .where((element) => element.habitCountDate == startTime);

    // 만약 습관 데이터가 없다면 데이터베이스에 새롭게 추가해줌
    if (results!.isEmpty) {
      var dailyHabit =
          DailyHabitCount(habitTypeId: habitData.id, habitCountDate: startTime);
      await _dailyHabitCount?.put(dailyHabit.id, dailyHabit);
    } else {
      // 1 더해준다.
      results.first.count += 1;
      await _dailyHabitCount?.put(results.first.id, results.first);
    }

    _dailyHabitCount?.values.toList().forEach((element) {
      print(element.id);
      print(element.habitTypeId);
      print(element.habitCountDate);
      print(element.count);
    });
  }

  Future<void> minusDailyHabit(HabitData habitData) async {
    DateTime toTime = DateTime.now();
    DateTime startTime = DateTime(toTime.year, toTime.month, toTime.day);

    // 오늘 생성한 습관이 있는지 확인
    var results = _dailyHabitCount?.values
        .toList()
        .where((element) => element.habitTypeId == habitData.id)
        .where((element) => element.habitCountDate == startTime);

    // 만약 습관 데이터가 없다면 데이터베이스에 새롭게 추가해줌
    if (results!.isNotEmpty) {
      // 1을 뺀다. 만약 targetCount보다 더 많이 달성할 경우 targetCount - 1을 리턴한다.
      results.first.count = results.first.count <= habitData.targetCount
          ? results.first.count - 1
          : habitData.targetCount - 1;
      // 0보다 작을 경우 0을 리턴한다.
      results.first.count = results.first.count < 0 ? 0 : results.first.count;

      await _dailyHabitCount?.put(results.first.id, results.first);
    }

    _dailyHabitCount?.values.toList().forEach((element) {
      print(element.id);
      print(element.habitTypeId);
      print(element.habitCountDate);
      print(element.count);
    });
  }

  // 각 날짜에 맞는 습관 데이터 리턴
  String getDateHabitCount(HabitData habitData, DateTime dateTime) {
    DateTime toTime = dateTime;
    DateTime startTime = DateTime(toTime.year, toTime.month, toTime.day);

    var results = _dailyHabitCount?.values
        .toList()
        .where((element) => element.habitTypeId == habitData.id)
        .where((element) => element.habitCountDate == startTime);

    if (results!.isEmpty) {
      return '0/${habitData.targetCount}';
    } else {
      if (results.first.count >= habitData.targetCount) {
        return '달성\u{1F389}';
      } else {
        return '${results.first.count}/${habitData.targetCount}';
      }
    }
  }

  // 달성하지않은 습관정보 개수 리턴
  int getNotAchieveHabitCount(DateTime dateTime) {
    DateTime toTime = dateTime;
    DateTime startTime = DateTime(toTime.year, toTime.month, toTime.day);

    var count = 0;
    _habitData?.values.toList().forEach((habit) {
      // 습관정보, 날짜에 맞는 습관 검색
      var data = _dailyHabitCount?.values
          .toList()
          .where((element) => element.habitTypeId == habit.id)
          .where((element) => element.habitCountDate == startTime);

      // 만약 값이 데이터베이스에 있다면
      if (data!.isNotEmpty) {
        print(habit.targetCount);
        if (data.first.count < habit.targetCount) {
          count++;
        }
      } else {
        count++;
      }
    });

    return count;
  }

  // 달성하지않은 습관정보 개수 리턴
  int getAchieveHabitCount(DateTime dateTime) {
    DateTime toTime = dateTime;
    DateTime startTime = DateTime(toTime.year, toTime.month, toTime.day);

    var count = 0;
    _habitData?.values.toList().forEach((habit) {
      // 습관정보, 날짜에 맞는 습관 검색
      var data = _dailyHabitCount?.values
          .toList()
          .where((element) => element.habitTypeId == habit.id)
          .where((element) => element.habitCountDate == startTime);

      // 만약 값이 데이터베이스에 있다면
      if (data!.isNotEmpty) {
        if (data.first.count >= habit.targetCount) {
          count++;
        }
      }
    });

    return count;
  }

  // 달성하지않은 습관정보 리턴
  List<HabitData> getNotAchieveHabitList(DateTime dateTime) {
    DateTime toTime = dateTime;
    DateTime startTime = DateTime(toTime.year, toTime.month, toTime.day);

    List<HabitData> list = [];
    _habitData?.values.toList().forEach((habit) {
      // 습관정보, 날짜에 맞는 습관 검색
      var data = _dailyHabitCount?.values
          .toList()
          .where((element) => element.habitTypeId == habit.id)
          .where((element) => element.habitCountDate == startTime);

      // 만약 값이 데이터베이스에 있다면
      if (data!.isNotEmpty) {
        if (data.first.count < habit.targetCount) {
          list.add(habit);
        }
      } else {
        list.add(habit);
      }
    });

    return list;
  }

  // 달성한 습관정보 리턴
  List<HabitData> getAchieveHabitList(DateTime dateTime) {
    DateTime toTime = dateTime;
    DateTime startTime = DateTime(toTime.year, toTime.month, toTime.day);

    List<HabitData> list = [];
    _habitData?.values.toList().forEach((habit) {
      // 습관정보, 날짜에 맞는 습관 검색
      var data = _dailyHabitCount?.values
          .toList()
          .where((element) => element.habitTypeId == habit.id)
          .where((element) => element.habitCountDate == startTime);

      // 만약 값이 데이터베이스에 있다면
      if (data!.isNotEmpty) {
        if (data.first.count >= habit.targetCount) {
          list.add(habit);
        }
      }
    });

    return list;
  }
}
