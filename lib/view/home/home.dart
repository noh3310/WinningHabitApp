import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_section_list/flutter_section_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:winning_habit/database/database.dart';
import 'package:winning_habit/view/home/add_habit.dart';
import 'package:winning_habit/view_model/view_model.dart';
import '../../database/habit_data.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ViewModel viewModel = ViewModel.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white24,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              // 날짜 리셋
              viewModel.setDate(DateTime.now());
            },
            icon: const Icon(Icons.refresh),
            color: Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                String text = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddHabit(state: AddHabitState.CREATE)));
                setState(() {
                  // print(text);
                });
              },
              icon: const Icon(Icons.add),
              color: Colors.black,
            ),
          ],
        ),
        body: StreamBuilder<DateTime>(
            stream: viewModel.date,
            builder: (context, snapshot) {
              return Column(
                children: [
                  CalendarView(),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: TableView(),
                  ),
                ],
              );
            }));
  }
}

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  ViewModel viewModel = ViewModel.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
        stream: viewModel.date,
        builder: (context, snapshot) {
          return TableCalendar(
            locale: 'ko-KR',
            // TODO: 시작일이랑 마감일을 수정해줘야한다.
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            focusedDay: snapshot.data!,
            calendarFormat: CalendarFormat.week,
            onDaySelected: (selectedDay, focusedDay) {
              viewModel.setDate(selectedDay);
              // setState(() {});
            },
            selectedDayPredicate: (day) {
              return isSameDay(snapshot.data!, day);
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
  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> with SectionAdapterMixin {
  ViewModel viewModel = ViewModel.instance;

  @override
  Widget build(BuildContext context) {
    return SectionListView.builder(adapter: this);
  }

  @override
  Widget getItem(BuildContext context, IndexPath indexPath) {
    return StreamBuilder<DateTime>(
        stream: viewModel.date,
        builder: (context, snapshot) {
          return Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(), // 모션
              key: ValueKey(indexPath.item),
              dismissible: DismissiblePane(onDismissed: () {
                print('hihi');
              }),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    DateTime now = DateTime.now();
                    DateTime date = DateTime(now.year, now.month, now.day);
                    DateTime snapShotTime = DateTime(snapshot.data!.year,
                        snapshot.data!.month, snapshot.data!.day);
                    if (snapShotTime == date) {
                      await DatabaseManager.instance.minusDailyHabit(indexPath
                                  .section ==
                              0
                          ? DatabaseManager.instance.getNotAchieveHabitList(
                              snapshot.data ?? DateTime.now())[indexPath.item]
                          : DatabaseManager.instance.getAchieveHabitList(
                              snapshot.data ?? DateTime.now())[indexPath.item]);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('당일만 습관을 달성할 수 있습니다.')));
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
                    DateTime now = DateTime.now();
                    DateTime date = DateTime(now.year, now.month, now.day);
                    DateTime snapShotTime = DateTime(snapshot.data!.year,
                        snapshot.data!.month, snapshot.data!.day);
                    if (snapShotTime == date) {
                      await DatabaseManager.instance.addDailyHabit(indexPath
                                  .section ==
                              0
                          ? DatabaseManager.instance.getNotAchieveHabitList(
                              snapshot.data ?? DateTime.now())[indexPath.item]
                          : DatabaseManager.instance.getAchieveHabitList(
                              snapshot.data ?? DateTime.now())[indexPath.item]);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('당일만 습관을 달성할 수 있습니다.')));
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
                  ? DatabaseManager.instance
                      .getNotAchieveHabitList(
                          snapshot.data ?? DateTime.now())[indexPath.item]
                      .name
                  : DatabaseManager.instance
                      .getAchieveHabitList(
                          snapshot.data ?? DateTime.now())[indexPath.item]
                      .name,
              //habitData![indexPath.section].name,
              percent: DatabaseManager.instance.getDateHabitCount(
                  indexPath.section == 0
                      ? DatabaseManager.instance.getNotAchieveHabitList(
                          snapshot.data ?? DateTime.now())[indexPath.item]
                      : DatabaseManager.instance.getAchieveHabitList(
                          snapshot.data ?? DateTime.now())[indexPath.item],
                  snapshot.data ?? DateTime.now()),
              color: indexPath.section == 0
                  ? Color(DatabaseManager.instance
                      .getNotAchieveHabitList(
                          snapshot.data ?? DateTime.now())[indexPath.item]
                      .color)
                  : Color(DatabaseManager.instance
                      .getAchieveHabitList(
                          snapshot.data ?? DateTime.now())[indexPath.item]
                      .color),
              habitData: indexPath.section == 0
                  ? DatabaseManager.instance.getNotAchieveHabitList(
                      snapshot.data ?? DateTime.now())[indexPath.item]
                  : DatabaseManager.instance.getAchieveHabitList(
                      snapshot.data ?? DateTime.now())[indexPath.item],
            ),
          );
        });
  }

  @override
  int numberOfItems(int section) {
    if (section == 0) {
      // 미달성한 습관개수 리턴
      return DatabaseManager.instance
          .getNotAchieveHabitCount(viewModel.getCurrentDate());
    } else {
      // 달성한 습관개수 리턴
      return DatabaseManager.instance
          .getAchieveHabitCount(viewModel.getCurrentDate());
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

class TableViewCell extends StatefulWidget {
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
  State<TableViewCell> createState() => _TableViewCellState();
}

class _TableViewCellState extends State<TableViewCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String text = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddHabit(
                      state: AddHabitState.MODIFY,
                      habitData: widget.habitData,
                    )));
        _TableViewState? parent = context.findAncestorStateOfType<_TableViewState>();
        parent?.setState(() {
          print('setState 호출');
        });
        setState(() {
          print(text);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.color,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: getTextColor(widget.color),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6.0),
              Text(
                widget.percent,
                style: TextStyle(
                  color: getTextColor(widget.color),
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
