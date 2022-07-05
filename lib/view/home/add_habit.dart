import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:winning_habit/database/database.dart';

import '../../database/habit_data.dart';

enum AddHabitState { CREATE, MODIFY }

class AddHabit extends StatelessWidget {
  AddHabit({Key? key, required this.state, this.habitData}) : super(key: key);

  AddHabitState state;
  HabitData? habitData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, '뒤로가기');
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(state == AddHabitState.CREATE ? '습관 추가' : '습관 수정',
            style: const TextStyle(
              color: Colors.black,
            )),
        elevation: 0.0,
        backgroundColor: Colors.white24,
      ),
      body: InputHabitData(state: state, habitData: habitData),
    );
  }
}

class InputHabitData extends StatefulWidget {
  InputHabitData({Key? key, required this.state, this.habitData}) : super(key: key);

  AddHabitState state;
  HabitData? habitData;

  @override
  State<InputHabitData> createState() => _InputHabitDataState(state: state, habitData: habitData);
}
class _InputHabitDataState extends State<InputHabitData> {
  _InputHabitDataState({required this.state, this.habitData}) {
    if (habitData == null) {
      print('null');
    } else {
      print(habitData?.id);
      print(habitData?.name);
      print(habitData?.color);
      print(habitData?.generateDate);
    }
    if (habitData != null) {
      habitName.text = habitData == null ? '' : habitData!.name;
      targetCount.text = habitData == null ? '' : habitData!.targetCount.toString();
      currentColor = Color(habitData!.color);
      pickerColor = Color(habitData!.color);
    }
  }

  // create some values
  Color pickerColor = Colors.black;// Color(0xff443a49);
  Color currentColor = Colors.black;//Color(0xff443a49);

  TextEditingController habitName = TextEditingController();
  TextEditingController targetCount = TextEditingController();

  AddHabitState state;
  HabitData? habitData;

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 10.0),
              CustomTextField(
                labelText: '습관이름(최대 20자)',
                hintText: '습관 이름을 입력하세요.',
                inputType: TextInputType.text,
                controller: habitName,
              ),
              CustomTextField(
                labelText: '목표 횟수(최대 100회)',
                hintText: '목표 횟수를 입력하세요.',
                inputType: TextInputType.number,
                controller: targetCount,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '습관 색',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: pickerColor,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // raise the [showDialog] widget
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('색상을 선택하세요'),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: pickerColor,
                                    onColorChanged: changeColor,
                                    enableAlpha: false,
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('선택'),
                                    onPressed: () {
                                      setState(
                                              () => currentColor = pickerColor);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: const Text('색상 선택'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Visibility(
              visible: state == AddHabitState.MODIFY ? true : false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    DatabaseManager.instance.removeHabitData(habitData);
                    Navigator.pop(context, '습관을 삭제했습니다.');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    elevation: 0.0,
                  ),
                  child: const Text('삭제하기'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (state == AddHabitState.CREATE) {
                    DatabaseManager manager = DatabaseManager();
                    // TODO: 입력값 제대로 입력했는지 체크하는 기능 추가해야함
                    manager.addHabit(
                        habitName.text, int.parse(targetCount.text),
                        currentColor.value);
                    Navigator.pop(context, '습관을 추가했습니다.');
                  } else {  // 업데이트
                    DatabaseManager manager = DatabaseManager();
                    // TODO: 입력값 제대로 입력했는지 체크하는 기능 추가해야함
                    manager.modifyHabit(
                        habitData!, habitName.text, int.parse(targetCount.text),
                        currentColor.value);
                    Navigator.pop(context, '습관을 수정했습니다.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  elevation: 0.0,
                ),
                child: Text(state == AddHabitState.CREATE ? '추가하기' : '수정하기'),
              ), // Padding
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ],
    );
  }
}


class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.inputType,
      required this.controller})
      : super(key: key);

  String labelText;
  String hintText;
  TextInputType inputType;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: const TextStyle(color: Colors.grey),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        keyboardType: inputType,
      ),
    );
  }
}
