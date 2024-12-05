import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';

import 'core.dart';

///A Try catch Wrapper for [Future<Either, T>]. Evaluates the function, handles
///errors and returns Left or Right.
FutureEither<T> futureHandler<T>(Future<T> Function() function) async {
  try {
    T result = await function();
    return Right(result);
  } on FirebaseException catch (e, stackTrace) {
    // A Firebase Exception has occurred
    log("A Firebase exception has occurred", name: "FIREBASE", stackTrace: stackTrace, error: e);
    return Left(Failure.firebase(message: e.message, stackTrace: stackTrace));
  }
  catch (e, stackTrace) {
    // An exception has occurred;
    log("An exception exception has occurred", error:  e, stackTrace: stackTrace, name: "FUTURE HANDLER");
    return Left(Failure.generic(message: e.toString(), stackTrace: stackTrace));
  }
}

Either<Failure, T> methodHandler<T>(T Function() function) {
  try {
    T result = function();
    return Right(result);
  } on FirebaseException catch (e, stackTrace) {
    // A Firebase Exception has occurred
    log("A Firebase exception has occurred", name: "FIREBASE", stackTrace: stackTrace, error: e);
    return Left(Failure.firebase(message: e.message, stackTrace: stackTrace));
  } catch (e, stackTrace) {
    // An exception has occurred;
    log("An exception exception has occurred", error:  e, stackTrace: stackTrace, name: "FUTURE HANDLER");
    return Left(Failure.generic(message: e.toString(), stackTrace: stackTrace));
  }
}
