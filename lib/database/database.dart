import 'package:hive_flutter/hive_flutter.dart';
import 'package:winning_habit/database/habit_data.dart';

class DatabaseManager {
  // Private한 생성자 생성
  DatabaseManager._privateConstructor();

  // 생성자를 호출하고 반환된 Singleton 인스턴스를 _instance 변수에 할당
  static final DatabaseManager _instance = DatabaseManager._privateConstructor();

  // Singleton() 호출시에 _instance 변수를 반환
  factory DatabaseManager() {
    return _instance;
  }

  late Box<HabitData>? _box;

  // 초기화
  Future<void> init() async {
    await Hive.initFlutter();
    // Hive에서는 typeId를 변경하면 안된다 만약 변경하려면 아래 코드를 작성한 후 Adapter를 등록해야한다.
    Hive.ignoreTypeId<HabitData>(3);
    // 생성된 어댑터를 등록해준다.
    Hive.registerAdapter(HabitDataAdapter());
    // // 제네릭을 선언해 habitData에는 Habitdata만 담을 수 있도록 설정
    await Hive.openBox<HabitData>('habitData');
    _box = await Hive.openBox('habitData');
  }

  // 습관 추가
  Future<void> addHabit(String name, int count) async {
    var habit =
        HabitData(name: name, generateDate: DateTime.now(), targetCount: count);
    // key값이 잘못 들어갈 수 있으므로 중복되는 값이 있다면 key를 새로 발급
    while (true) {
      final temp = _box?.get(habit.id);
      if (temp == null) {
        break;
      } else {
        // 새로 발급
        habit.id = uuid.v4();
      }
    }
    await _box?.add(habit);
    final datas = _box!.values.toList();
    datas.forEach((element) {
      print(element.name);
    });
  }

  List<HabitData>? getHabitData() {
    return _box?.values.toList();
  }
}
