import 'package:cybersafe_pro/repositories/driff_db/models/category_drift_model.dart';
import 'package:cybersafe_pro/repositories/driff_db/models/icon_custom_drift_model.dart';
import 'package:drift/drift.dart';

class AccountDriftModel extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get username => text().nullable()();
  TextColumn get password => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get icon => text().nullable()();
  IntColumn get openCount => integer().withDefault(const Constant(0))();
  IntColumn get categoryId => integer().references(CategoryDriftModel, #id)();
  IntColumn get iconCustomId => integer().nullable().references(IconCustomDriftModel, #id)();
  DateTimeColumn get passwordUpdatedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
