import 'package:cybersafe_pro/repositories/driff_db/models/account_drift_model.dart';
import 'package:drift/drift.dart';

class TOTPDriftModel extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(AccountDriftModel, #id)();
  TextColumn get secretKey => text()();
  BoolColumn get isShowToHome => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

