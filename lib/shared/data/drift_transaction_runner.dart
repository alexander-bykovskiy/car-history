import '../domain/transaction_runner.dart';
import 'db/app_database.dart';

class DriftTransactionRunner implements TransactionRunner {
  DriftTransactionRunner(this._db);

  final AppDatabase _db;

  @override
  Future<T> runInTransaction<T>(Future<T> Function() action) {
    return _db.transaction(action);
  }
}
