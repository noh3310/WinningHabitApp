import 'package:rxdart/rxdart.dart';

class ViewModel {
  // Private한 생성자 생성
  ViewModel._privateConstructor();

  // 생성자를 호출하고 반환된 Singleton 인스턴스를 instance 변수에 할당
  static final ViewModel instance = ViewModel._privateConstructor();

  final BehaviorSubject<DateTime> _selectDate = BehaviorSubject<DateTime>.seeded(DateTime.now());
  Stream<DateTime> get date => _selectDate.stream;

  void setDate(DateTime dateTime) {
    _selectDate.sink.add(dateTime);
  }

  DateTime getCurrentDate() {
    return _selectDate.valueOrNull ?? DateTime.now();
  }
}