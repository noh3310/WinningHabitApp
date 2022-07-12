import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_section_list/flutter_section_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:winning_habit/database/database.dart';
import 'package:winning_habit/view/home/add_habit.dart';
import 'package:winning_habit/view_model/get_view_model.dart';
import '../../database/habit_data.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  final GetViewModel date = Get.put(GetViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            // 날짜 리셋
            date.updateDate(DateTime.now());
          },
          icon: const Icon(Icons.refresh),
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(() => AddHabit(state: AddHabitState.CREATE),
                  transition: Transition.downToUp);
              date.updateDate(DateTime.now());
            },
            icon: const Icon(Icons.add),
            color: Colors.black,
          ),
        ],
      ),
      body: Column(
        children: const [
          CalendarView(),
          SizedBox(height: 10.0),
          Expanded(
            child: TableView(),
          ),
        ],
      ),
    );
  }
}

class CalendarView extends StatelessWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<GetViewModel>(builder: (date) {
      return TableCalendar(
        locale: 'ko-KR',
        // TODO: 시작일이랑 마감일을 수정해줘야한다.
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        focusedDay: date.dateTime.value,
        calendarFormat: CalendarFormat.week,
        onDaySelected: (selectedDay, focusedDay) {
          date.updateDate(selectedDay);
        },
        selectedDayPredicate: (day) {
          return isSameDay(date.dateTime.value, day);
        },
        calendarStyle: const CalendarStyle(
          isTodayHighlighted: true,
          selectedDecoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.circle,
          ),
        ),
      );
    });
  }
}

class TableView extends StatefulWidget {
  const TableView({Key? key}) : super(key: key);

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> with SectionAdapterMixin {
  @override
  Widget build(BuildContext context) {
    return GetX<GetViewModel>(builder: (date) {
      return SectionListView.builder(adapter: this);
    });
  }

  @override
  Widget getItem(BuildContext context, IndexPath indexPath) {
    DateTime now = DateTime.now();
    DateTime nowDate = DateTime(now.year, now.month, now.day);

    return GetX<GetViewModel>(builder: (date) {
      final dateData = date.dateTime.value; //.data ?? nowDate;
      final snapShotDate =
          DateTime(dateData.year, dateData.month, dateData.day);
      final databaseManager = DatabaseManager();
      final notAchieveHabitList =
          databaseManager.getNotAchieveHabitList(snapShotDate);
      final achieveHabitList =
          databaseManager.getAchieveHabitList(snapShotDate);

      return Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(), // 모션
          key: ValueKey(indexPath.item),
          children: [
            SlidableAction(
              onPressed: (context) async {
                if (snapShotDate == nowDate) {
                  await databaseManager.minusDailyHabit(indexPath.section == 0
                      ? notAchieveHabitList[indexPath.item]
                      : achieveHabitList[indexPath.item]);
                } else {
                  Get.snackbar('습관추가 실패', '당일만 습관을 달성할 수 있습니다.',
                      snackPosition: SnackPosition.TOP,
                      animationDuration: const Duration(seconds: 1),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.white);
                }
                setState(() {});
              },
              foregroundColor: Colors.redAccent,
              icon: Icons.exposure_minus_1,
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                if (snapShotDate == nowDate) {
                  await databaseManager.addDailyHabit(indexPath.section == 0
                      ? notAchieveHabitList[indexPath.item]
                      : achieveHabitList[indexPath.item]);
                } else {
                  Get.snackbar('습관추가 실패', '당일만 습관을 달성할 수 있습니다.',
                      snackPosition: SnackPosition.TOP,
                      animationDuration: const Duration(seconds: 1),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.white);
                }
                setState(() {});
              },
              foregroundColor: Colors.blueAccent,
              icon: Icons.plus_one,
            ),
          ],
        ),
        child: TableViewCell(
          title: indexPath.section == 0
              ? notAchieveHabitList[indexPath.item].name
              : achieveHabitList[indexPath.item].name,
          percent: databaseManager.getDateHabitCount(
              indexPath.section == 0
                  ? notAchieveHabitList[indexPath.item]
                  : achieveHabitList[indexPath.item],
              snapShotDate),
          color: indexPath.section == 0
              ? Color(notAchieveHabitList[indexPath.item].color)
              : Color(achieveHabitList[indexPath.item].color),
          habitData: indexPath.section == 0
              ? notAchieveHabitList[indexPath.item]
              : achieveHabitList[indexPath.item],
        ),
      );
    });
  }

  @override
  int numberOfItems(int section) {
    final databaseManager = DatabaseManager();
    GetViewModel data = Get.find();
    if (section == 0) {
      // 미달성한 습관개수 리턴
      return databaseManager.getNotAchieveHabitCount(data.dateTime.value);
    } else {
      // 달성한 습관개수 리턴
      return databaseManager.getAchieveHabitCount(data.dateTime.value);
    }
  }

  @override
  int numberOfSections() {
    // TODO: implement numberOfSections
    return 2;
  }

  @override
  bool shouldExistSectionHeader(int section) {
    return true;
  }

  @override
  Widget getSectionHeader(BuildContext context, int section) {
    return Container(
      key: GlobalKey(debugLabel: 'header $section'),
      height: 20,
      color: Colors.white10,
      child: Row(
        children: [
          const SizedBox(width: 15),
          Text(section == 0 ? '미완료된 습관' : '완료된 습관'),
        ],
      ),
    );
  }
}

class TableViewCell extends StatelessWidget {
  String title;
  String percent;
  Color color;
  HabitData habitData;

  TableViewCell(
      {Key? key,
      required this.title,
      required this.percent,
      required this.color,
      required this.habitData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetViewModel data = Get.find();
    return GestureDetector(
      onTap: () async {
        await Get.to(
            () => AddHabit(state: AddHabitState.MODIFY, habitData: habitData),
            transition: Transition.downToUp);
        data.updateDate(DateTime.now());
      },
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: getTextColor(color),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6.0),
              Text(
                percent,
                style: TextStyle(
                  color: getTextColor(color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getTextColor(Color color) {
    final sum = color.red + color.green + color.blue;
    final average = sum / 3;
    if (average > 255 / 2) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }
}
