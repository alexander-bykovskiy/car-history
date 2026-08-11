/// Port for running multi-step writes atomically.
///
/// Implementations must roll back all DB work when [action] throws.
abstract class TransactionRunner {
  Future<T> runInTransaction<T>(Future<T> Function() action);
}
