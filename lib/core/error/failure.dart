import 'package:equatable/equatable.dart';

import 'exceptions.dart';

class Failure extends Equatable {
  final String? message;
  final int? code;
  final StackTrace? stackTrace;

  const Failure({
    this.message = "An error has occurred",
    this.code,
    this.stackTrace,
  });
  const Failure.generic({
    this.message = "An error has occurred",
    this.code,
    this.stackTrace,
  });
  const Failure.api({
    this.message = "An API error has occurred",
    this.code,
    this.stackTrace,
  });
  const Failure.firebase({
    this.message = "An Firebase error has occurred",
    this.code,
    this.stackTrace,
  });
  const Failure.network({
    this.message = "No internet, try connecting to a network",
    this.code,
    this.stackTrace,
  });
  const Failure.storage({
    this.message = "A local storage error has occurred",
    this.code,
    this.stackTrace,
  });

  factory Failure.fromApi(AppException exception) {
    ///Todo: Properly implement failure types from Api
    if (exception.code != null) {
      if (exception.code.toString().startsWith('4')) {
        return Failure.api(
          message:
              exception.message.isNotEmpty ? exception.message : "Not Found",
          code: exception.code,
          stackTrace: exception.stackTrace,
        );
      }

      if (exception.code.toString().startsWith('5')) {
        return Failure.api(
          message:
              exception.message.isNotEmpty
                  ? exception.message
                  : "Internal Server Error",
          code: exception.code,
          stackTrace: exception.stackTrace,
        );
      }

      if (exception.code.toString().startsWith('3')) {
        return Failure.api(
          message:
              exception.message.isNotEmpty ? exception.message : "Bad Request",
          code: exception.code,
          stackTrace: exception.stackTrace,
        );
      }

      if (exception.code.toString().startsWith('2')) {
        return Failure.api(
          message: exception.message.isNotEmpty ? exception.message : "OK",
          code: exception.code,
          stackTrace: exception.stackTrace,
        );
      }

      if (exception.code.toString().startsWith('1')) {
        return Failure.api(
          message:
              exception.message.isNotEmpty
                  ? exception.message
                  : "Not Implemented",
          code: exception.code,
          stackTrace: exception.stackTrace,
        );
      }
    } else {
      return Failure.api(
        message:
            exception.message.isNotEmpty
                ? exception.message
                : "An unknown API error has occurred",
        code: exception.code,
        stackTrace: exception.stackTrace,
      );
    }
    return Failure.api(
      message:
          exception.message.isNotEmpty
              ? exception.message
              : "An unknown API error has occurred",
      code: exception.code,
      stackTrace: exception.stackTrace,
    );
  }

  @override
  List<Object?> get props => [message, code, stackTrace];
}
