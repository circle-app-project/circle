import 'dart:developer';
import 'package:circle/core/error/exceptions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';

import '../../crashytics_service.dart';
import '../core.dart';

/// A utility function to handle asynchronous operations that return a
/// [FutureEither<T>] or [Either<Failure, T>].
///
/// This function wraps the provided asynchronous [function] call in a try-catch block,
/// automatically handles exceptions, and returns a [Right] if successful or a [Left]
/// containing the appropriate [Failure] if an error occurs.
///
/// #### Error Handling:
/// - Handles [AppException] types and maps them to specific [Failure] types based on
///   the `ExceptionType` (e.g., `api`, `network`, `localStorage`, `generic`).
/// - Logs all exceptions and their stack traces using the Dart [log] utility.
/// - Provides a place for integrating error reporting (e.g., Crashlytics).
///
/// #### Example:
/// ```dart
/// final FutureEither<T> result = await futureHandler(() async {
///   return await fetchUserData();
/// });
/// result.fold(
///   (failure) => handleFailure(failure),
///   (data) => processData(data),
/// );
/// ```
///
/// #### Parameters:
/// - [function]: A [Future]-returning function that will be executed and evaluated.
///
/// #### Returns:
/// - A [FutureEither] with itself is a type def of [Future<Either<Failure, T>>] containing:
///   - [Right] if the operation succeeds, wrapping the result of type [T].
///   - [Left] if an exception is caught, wrapping a [Failure] instance.
FutureEither<T> futureHandler<T>(Future<T> Function() function) async {
  try {
    T result = await function();
    return Right(result);
  } on FirebaseException catch (e, stackTrace) {
    // A Firebase Exception has occurred
    log(
      "A Firebase exception has occurred: ${e.message}",
      name: "Future Handler",
      stackTrace: stackTrace,
      error: e,
    );

    // Log this caught exception to Crashlytics
    CrashlyticsService.recordError(
      error: e,
      stack: stackTrace,
      reason: "A Firebase exception has occurred",
      information: [
        "Future Handler",
        "Firebase Error",
        e.plugin,
        e.code,
        e.message ?? "",
        e.stackTrace ?? "",
      ],
    );
    return Left(Failure.firebase(message: e.message ?? "A Firebase exception has occurred", stackTrace: stackTrace));
  } on AppException catch (e, stackTrace) {
    log(
      "An app exception has occurred: ${e.message}",
      error: e,
      stackTrace: stackTrace,
      name: "Method Handler",
    );
    switch (e.type) {
      case ExceptionType.api:
        return Left(Failure.fromApi(e));
      case ExceptionType.network:
        return Left(
          Failure.network(
            message: e.message,
            code: e.code,
            stackTrace: e.stackTrace,
          ),
        );
      case ExceptionType.localStorage:
        return Left(
          Failure.storage(
            message: e.message,
            code: e.code,
            stackTrace: e.stackTrace,
          ),
        );
      case ExceptionType.generic:
        return Left(
          Failure.generic(
            message: e.message,
            code: e.code,
            stackTrace: e.stackTrace,
          ),
        );

      case ExceptionType.firebase:
        return Left(
          Failure.firebase(message: e.message, stackTrace: e.stackTrace),
        );
    }
  } catch (e, stackTrace) {
    // An exception has occurred;
    log(
      "An exception exception has occurred",
      error: e,
      stackTrace: stackTrace,
      name: "Future Handler",
    );

    // Log this caught exception to Crashlytics
    CrashlyticsService.recordError(
      error: e,
      stack: stackTrace,
      reason: "An exception exception has occurred",
      information: ["Future Handler", "Generic Error", e.toString()],
    );

    return Left(Failure.generic(message: e.toString(), stackTrace: stackTrace));
  }
}


/// A utility function to handle synchronous operations that return an
/// [Either<Failure, T>].
///
/// This function wraps the provided synchronous [function] call in a try-catch block,
/// automatically handles exceptions, and returns a [Right] if successful or a [Left]
/// containing the appropriate [Failure] if an error occurs.
///
/// #### Error Handling:
/// - Handles [AppException] types and maps them to specific [Failure] types based on
///   the `ExceptionType` (e.g., `api`, `network`, `localStorage`, `generic`).
/// - Logs all exceptions and their stack traces using the Dart [log] utility.
/// - Provides a place for integrating error reporting (e.g., Crashlytics).
///
/// #### Example:
/// ```dart
/// final Either<Failure, T> result = methodHandler(() {
///   return calculateSum(10, 20);
/// });
/// result.fold(
///   (failure) => handleFailure(failure),
///   (data) => processResult(data),
/// );
/// ```
///
/// #### Parameters:
/// - [function]: A synchronous function that will be executed and evaluated.
///
/// #### Returns:
/// - An [Either] containing:
///   - [Right] if the operation succeeds, wrapping the result of type [T].
///   - [Left] if an exception is caught, wrapping a [Failure] instance.
Either<Failure, T> methodHandler<T>(T Function() function) {
  try {
    T result = function();
    return Right(result);
  } on FirebaseException catch (e, stackTrace) {
    // A Firebase Exception has occurred
    log(
      "A Firebase exception has occurred: ${e.message}",
      name: "Method Handler",
      stackTrace: stackTrace,
      error: e,
    );
    return Left(Failure.firebase(message: e.message ?? "A Firebase exception has occurred", code: int.tryParse(e.code), stackTrace: stackTrace));
  } on AppException catch (e, stackTrace) {
    log(
      "An app exception has occurred: ${e.message}",
      error: e,
      stackTrace: stackTrace,
      name: "Method Handler",
    );
    switch (e.type) {
      case ExceptionType.api:
        return Left(Failure.fromApi(e));
      case ExceptionType.network:
        return Left(
          Failure.network(
            message: e.message,
            code: e.code,
            stackTrace: e.stackTrace,
          ),
        );
      case ExceptionType.localStorage:
        return Left(
          Failure.storage(
            message: e.message,
            code: e.code,
            stackTrace: e.stackTrace,
          ),
        );
      case ExceptionType.generic:
        return Left(
          Failure.generic(
            message: e.message,
            code: e.code,
            stackTrace: e.stackTrace,
          ),
        );

      case ExceptionType.firebase:
        return Left(
          Failure.firebase(message: e.message, code: e.code, stackTrace: e.stackTrace),
        );
    }
  } catch (e, stackTrace) {
    // An exception has occurred;
    log(
      "An exception exception has occurred",
      error: e,
      stackTrace: stackTrace,
      name: "Method Handler",
    );
    // Log this caught exception to Crashlytics
    CrashlyticsService.recordError(
      error: e,
      stack: stackTrace,
      reason: "An exception exception has occurred",
      information: ["Method Handler", "Generic Error", e.toString()],
    );
    return Left(Failure.generic(message: e.toString(),  stackTrace: stackTrace));
  }
}
