/// A simple, user-facing error surfaced by services/repositories and rendered
/// by the UI (via `AsyncValue.error`). Keeps the web app free of the mobile
/// app's fpdart `Either`/`Failure` machinery — Riverpod's `AsyncValue.guard`
/// handles the functional error flow here.
class AdminException implements Exception {
  AdminException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AdminException: $message';
}
