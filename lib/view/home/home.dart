import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_section_list/flutter_section_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
        children: [
          CalendarView(),
          const SizedBox(height: 10.0),
          Expanded(
            child: TableView(),
          ),
        ],
      ),
    );
  }
}

class CalendarView extends StatelessWidget {
  CalendarView({Key? key}) : super(key: key);
  final GetViewModel date = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => TableCalendar(
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
        ));
  }
}

class TableView extends StatelessWidget with SectionAdapterMixin {
  TableView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => SectionListView.builder(adapter: this));
  }

  @override
  Widget getItem(BuildContext context, IndexPath indexPath) {
    final GetViewModel date = Get.find();

    return Obx(() => Slidable(
          startActionPane: ActionPane(
            motion: const ScrollMotion(), // 모션
            key: ValueKey(indexPath.item),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  final habitData =
                      date.getHabitData(indexPath.section, indexPath.item);
                  final result = await date.habitAchievement(
                      habitData, HabitAchieveState.minus);

                  if (result == false) {
                    Get.snackbar('습관추가 실패', '당일만 습관을 달성할 수 있습니다.',
                        snackPosition: SnackPosition.TOP,
                        animationDuration: const Duration(seconds: 1),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.white);
                  }
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
                  final habitData =
                      date.getHabitData(indexPath.section, indexPath.item);
                  final result = await date.habitAchievement(
                      habitData, HabitAchieveState.add);

                  if (result == false) {
                    Get.snackbar('습관추가 실패', '당일만 습관을 달성할 수 있습니다.',
                        snackPosition: SnackPosition.TOP,
                        animationDuration: const Duration(seconds: 1),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.white);
                  }
                },
                foregroundColor: Colors.blueAccent,
                icon: Icons.plus_one,
              ),
            ],
          ),
          child: TableViewCell(
            title: date.getHabitData(indexPath.section, indexPath.item).name,
            percent: date.getCountString(
                date.getHabitData(indexPath.section, indexPath.item)),
            color: Color(
                date.getHabitData(indexPath.section, indexPath.item).color),
            habitData: date.getHabitData(indexPath.section, indexPath.item),
          ),
        ));
  }

  @override
  int numberOfItems(int section) {
    GetViewModel data = Get.find();
    return data.getCount(section);
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
