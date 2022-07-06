import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key? key,
        required this.labelText,
        required this.hintText,
        required this.inputType,
        required this.controller,
        this.maxLines,
        this.maxLength})
      : super(key: key);

  String labelText;
  String hintText;
  TextInputType? inputType;
  TextEditingController controller;
  int? maxLines;
  int? maxLength;

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
        maxLines: maxLines == null ? null : 1,
        maxLength: maxLength,
        onChanged: (String str) {
          // 최대값을 100으로 설정
          if (str.length >= 3 && inputType == TextInputType.number) {
            controller.text = '100';
          }
        },
      ),
    );
  }
}
