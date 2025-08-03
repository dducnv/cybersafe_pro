import 'package:cybersafe_pro/repositories/driff_db/models/account_drift_model.dart';
import 'package:drift/drift.dart';

class PasswordHistoryDriftModel extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(AccountDriftModel, #id)();
  TextColumn get password => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
