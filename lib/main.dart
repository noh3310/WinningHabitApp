import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:winning_habit/view/chart/chart.dart';
import 'package:winning_habit/view/home/home.dart';
import 'package:winning_habit/view/setting/setting.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:hive/hive.dart';
import 'package:winning_habit/database/habit_data.dart';

void main() async {
  await Hive.initFlutter();
  // 생성된 어댑터를 등록해준다.
  Hive.registerAdapter(HabitDataAdapter());
  // 제네릭을 선언해 habitData에는 Habitdata만 담을 수 있도록 설정
  await Hive.openBox<HabitData>('habitData');

  Box<HabitData> box = await Hive.openBox('habitData');
  final _todo = HabitData(name: "hihi", generateDate: DateTime.now(), targetCount: 2);
  await box.put(_todo.id, _todo);
  print(box.values.first.name);

  initializeDateFormatting('ko_KR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WinningHabit - 습관개선 앱',
      home: NavigationBar(),
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = [
    HomeView(),
    ChartView(),
    SettingView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
