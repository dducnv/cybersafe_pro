import 'package:cybersafe_pro/repositories/driff_db/models/account_drift_model.dart';
import 'package:drift/drift.dart';

class AccountCustomFieldDriftModel extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(AccountDriftModel, #id)();
  TextColumn get name => text()();
  TextColumn get value => text()();
  TextColumn get hintText => text()();
  TextColumn get typeField => text()();
}
