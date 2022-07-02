import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:winning_habit/database/database.dart';

enum AddHabitState { CREATE, MODIFY }

class AddHabit extends StatelessWidget {
  AddHabit({Key? key, required this.state}) : super(key: key);

  AddHabitState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: const Text('습관 추가',
            style: TextStyle(
              color: Colors.black,
            )),
        elevation: 0.0,
        backgroundColor: Colors.white24,
      ),
      body: InputHabitData(state: state),
    );
  }
}

class InputHabitData extends StatefulWidget {
  InputHabitData({Key? key, required this.state}) : super(key: key);

  AddHabitState state;

  @override
  State<InputHabitData> createState() => _InputHabitDataState(state: state);
}

class _InputHabitDataState extends State<InputHabitData> {
  _InputHabitDataState({required this.state});

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  AddHabitState state;

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
              ),
              CustomTextField(
                labelText: '목표 횟수(최대 100회)',
                hintText: '목표 횟수를 입력하세요.',
                inputType: TextInputType.number,
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
                                title: const Text('Pick a color!'),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: pickerColor,
                                    onColorChanged: changeColor,
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('Got it'),
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
                    Navigator.pop(context);
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
                  DatabaseManager manager = DatabaseManager();
                  manager.addHabit('추가', 10);
                  Navigator.pop(context);
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
      required this.inputType})
      : super(key: key);

  String labelText;
  String hintText;
  TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
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
