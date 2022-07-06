# winning_habit

- 습관을 등록하고 습관을 달성할 수 있는 앱

## 앱 기능

- 습관 등록
  - 색상 선택
  - 목표횟수 입력
- 습관 달성하기
  - 습관 달성
  - 습관 취소
- 통계 보기
  - 1주일간 통계

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
- webview_flutter: 3.0.4
- get: 4.6.5

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
- 기능구현을 완료한 후 GetX을 사용해 라우트, 상태관리 부분을 적용했다. 기존 코드에서는 BehaviorSubject(RxDart)를 사용해 날짜데이터를 저장하고,
  StreamBuilder를 통해 Widget에 보여줬다, GetX 적용 후 Rx<DateTime>를 사용해 날짜를 저장하고, GetX<'GetX클래스'>를 통해 위젯에
  반영했다. 
- 기존 코드에서는 부모 위젯의 위치를 찾아 setState 메서드를 호출했어야했지만, GetX 적용 후에는 간단하게 사용할 수 있었다.
    ```Dart
  // 데이터에 접근
  GetViewModel data = Get.find();
  // 데이터 업데이트
  data.updateDate(DateTime.now());
    ```
- 이번 프로젝트에서는 Flutter에서 많이 사용하고있는 Hive 데이터베이스를 사용했고, 학습기간에 시간이 필요했다. 평소 알고있는 NoSQL 언어와는 다르게 기본키(_id)
  타입이 존재하지 않았다. UUID타입을 사용해 각 데이터를 구분했다.