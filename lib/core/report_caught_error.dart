import 'dart:developer' as developer;

/// Logs an unexpected catch for diagnostics without changing user-facing UX.
///
/// Prefer `catch (e, st)` + [reportCaughtError] over bare `catch (_)`.
void reportCaughtError(
  Object error,
  StackTrace stackTrace, {
  required String context,
}) {
  developer.log(
    '$error',
    name: context,
    error: error,
    stackTrace: stackTrace,
  );
}
