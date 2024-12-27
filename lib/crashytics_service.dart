import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

///Todo: Eventually enable opt in reporting, so users can decide to participate in error reporing or not
/// See https://firebase.google.com/docs/crashlytics/customize-crash-reports?platform=flutter#get-breadcrumb-logs for more details
class CrashlyticsService {
  static void initialize() {
    final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      if (_isFatalError(errorDetails)) {
        // Pass all uncaught "fatal" errors from the framework to Crashlytics
        crashlytics.recordFlutterFatalError(errorDetails);
      } else {
        // Pass all uncaught standard errors to Crashlytics
        crashlytics.recordFlutterError(errorDetails);
      }
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  static void recordFlutterError(FlutterErrorDetails errorDetails) async {
    final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.recordFlutterError(errorDetails);
  }

  static void recordError({
    required Object error,
    required StackTrace stack,
    String? reason,
    Iterable<Object> information = const [],
  }) async {
    final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.recordError(
      error,
      stack,
      reason: reason,
      information: information,
    );
  }

  static bool _isFatalError(FlutterErrorDetails errorDetails) {
    // Check the type of exception
    final exception = errorDetails.exception;
    if (exception is OutOfMemoryError ||
        exception is AssertionError) {
      return true; // Critical errors
    }

    // Check the error context for specific fatal cases
    if (errorDetails.context?.toString().contains('Critical') == true ||
        errorDetails.context?.toString().contains('Fatal') == true) {
      return true; // Custom-defined "critical" errors
    }

    // Default to non-fatal
    return false;
  }
}
