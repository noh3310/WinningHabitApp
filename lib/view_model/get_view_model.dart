import 'package:get/get.dart';

class GetViewModel extends GetxController {

  Rx<DateTime> dateTime = DateTime.now().obs;

  void updateDate(DateTime newDate) {
    dateTime.value= newDate;
  }
}