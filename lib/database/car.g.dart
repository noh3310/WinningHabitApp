part of 'database.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Car extends _Car with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  Car(
      String make, {
        String? model,
        int? kilometers = 500,
        String? owner,
      }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<Car>({
        'kilometers': 500,
      });
    }
    RealmObject.set(this, 'make', make);
    RealmObject.set(this, 'model', model);
    RealmObject.set(this, 'kilometers', kilometers);
    RealmObject.set(this, 'owner', owner);
  }

  Car._();

  @override
  String get make => RealmObject.get<String>(this, 'make') as String;
  @override
  set make(String value) => RealmObject.set(this, 'make', value);

  @override
  String? get model => RealmObject.get<String>(this, 'model') as String?;
  @override
  set model(String? value) => RealmObject.set(this, 'model', value);

  @override
  int? get kilometers => RealmObject.get<int>(this, 'kilometers') as int?;
  @override
  set kilometers(int? value) => RealmObject.set(this, 'kilometers', value);

  @override
  String? get owner => RealmObject.get<String>(this, 'owner') as String?;
  @override
  set owner(covariant String? value) => RealmObject.set(this, 'owner', value);

  @override
  Stream<RealmObjectChanges<Car>> get changes =>
      RealmObject.getChanges<Car>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Car._);
    return const SchemaObject(Car, 'Car', [
      SchemaProperty('make', RealmPropertyType.string),
      SchemaProperty('model', RealmPropertyType.string, optional: true),
      SchemaProperty('kilometers', RealmPropertyType.int, optional: true),
      SchemaProperty('owner', RealmPropertyType.object,
          optional: true, linkTarget: 'Person'),
    ]);
  }
}