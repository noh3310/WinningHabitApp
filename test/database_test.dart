import 'package:winning_habit/database/database.dart';

void main() {
  var database = DatabaseManager();
  database.createRealm();
}