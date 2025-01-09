class AppException implements Exception {
  final String? debugMessage;
  final String message;
  final int? code;
  final StackTrace? stackTrace;
  final ExceptionType type;

  AppException({
    required this.message,
    this.code,
    this.stackTrace,
    this.debugMessage,
    this.type = ExceptionType.generic,
  });

  @override
  String toString() {
    return "${type.name} Exception: $message, ${code != null ? ' Code: $code' : ''}";
  }
}

enum ExceptionType { api, network, localStorage, generic, firebase }
