import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartView extends StatelessWidget {
  const ChartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('통계', style: TextStyle(color: Colors.black)),
        elevation: 0.0,
        backgroundColor: Colors.white24,
      ),
      body: const HabitChart(),
    );
  }
}

class HabitChart extends StatefulWidget {
  const HabitChart({Key? key}) : super(key: key);

  @override
  State<HabitChart> createState() => _HabitChartState();
}

class _HabitChartState extends State<HabitChart> {
  final Color barBackgroundColor = Colors.redAccent; //Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Card(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white, //Color(0xff81e5cd),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const Text(
                  '주간 달성률(%)',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: BarChart(
                      mainBarData(),
                      swapAnimationDuration: animDuration,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.blueAccent,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.blue : barColor,
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.yellow, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          // backDrawRodData: BackgroundBarChartRodData(
          //   show: true,
          //   toY: 20,
          //   color: barBackgroundColor,
          // ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  // 데이터 값
  List<BarChartGroupData> showingGroups() =>
      List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 100, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 10, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 70, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 78, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 30, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 0, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 1, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        // leftTitles: AxisTitles(
        //   sideTitles: SideTitles(
        //     showTitles: false,
        //   ),
        // ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  // 하단 타이틀
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('6일전', style: style);
        break;
      case 1:
        text = const Text('5일전', style: style);
        break;
      case 2:
        text = const Text('4일전', style: style);
        break;
      case 3:
        text = const Text('3일전', style: style);
        break;
      case 4:
        text = const Text('2일전', style: style);
        break;
      case 5:
        text = const Text('1일전', style: style);
        break;
      case 6:
        text = const Text('오늘', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
