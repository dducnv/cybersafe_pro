import 'package:drift/drift.dart';

class CategoryDriftModel extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get categoryName => text()();
  IntColumn get indexPos => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}