import 'package:realm/realm.dart';
part 'car.g.dart';

@RealmModel()
class _Car {
  late String make;
  String? model;
  int? kilometers = 500;
  String? owner;
}

class DatabaseManager {
  var config;
  var realm;
  var car;
  var cars;

  void createRealm() async {
    config = Configuration.local([Car.schema]);
    realm = Realm(config);
    cars = realm.all<Car>();

    car = Car('Tesla', model: 'Model Y', kilometers: 1, owner: 'Tom');
    await realm.write(() {
      realm.add(car);
    });

    await realm.all<Car>().changes.listen((e) {
      print("listen callback called");
    });


    var myCar = cars[0];
    print('My car is ${myCar.make} ${myCar.model}');
  }
}