/// Thrown inside [TransactionRunner.runInTransaction] to force a rollback
/// while still returning a typed domain failure to the caller.
class TransactionAbort<T> implements Exception {
  TransactionAbort(this.result);

  final T result;

  @override
  String toString() => 'TransactionAbort($result)';
}
