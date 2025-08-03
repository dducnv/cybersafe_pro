import 'package:drift/drift.dart';

class IconCustomDriftModel extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get imageBase64 => text()();
}