# winning_habit
- 습관을 등록하고 습관을 달성할 수 있는 앱

## 앱 기능
- 습관 등록
- 습관 달성하기
- 통계 보기

## 개발공수
[개발 공수](https://jerryco.notion.site/WinningHabit-Flutter-67a9c70ab7e44e33ad85d7f1e418714e)

## 커밋 컨벤션
- 기능 추가: feat
- 기능 수정: mod
- 오류 수정: fix

## 사용 라이브러리
- table_calendar: 3.0.6
- intl: 0.17.0
- flutter_section_list: 1.1.0
- flutter_slidable: 1.3.0
- flutter_colorpicker: 1.0.3
- fl_chart: 0.55.0
- hive: 2.2.3
- hive_flutter: 1.1.0
- uuid: 3.0.6
- rxdart: 0.27.4

## Issue
- StatefulWidget의 특정 오브젝트의 상태를 변경하기 위해서는 setState(()) {};를 사용해야 한다.
- Hive 데이터베이스를 사용할 때 처음 Adadper를 생성할 때 TypeId를 변경하면 안된다. 만약 변경하려면 아래 코드를 작성 후 Adapter를 등록해야한다.
    ```Dart
  Hive.ignoreTypeId<'변경된 어댑터'>('변경전 TypeId');
    ```
- Hive의 데이터를 삭제하려면 아래 코드를 실행하면 된다.
  ```Dart
  '삭제할 Box'.deleteFromDisk();
  ```
- 부모위젯의 setState 메서드를 호출해야 하는 경우가 있었다.
  - 아래 코드를 작성하고 실행하면 된다.
    ```Dart
    '부모 위젯' parent = context.findAncestorStateOfType<'부모 위젯'>();
    parent.setState(() {});
```