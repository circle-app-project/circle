import 'dart:developer';

import '../../../../core/error/exceptions.dart';
import '../../../../objectbox.g.dart';
import '../../models/hla_test_request.dart';

/// Optional ObjectBox cache for HLA requests (plan §D5). Firestore is the
/// realtime source of truth; this lets the requests list render last-known
/// data while offline. Kept deliberately thin for the MVP.
class HlaLocalService {
  late final Box<HlaTestRequest> _requestBox;

  HlaLocalService({required Store store})
      : _requestBox = store.box<HlaTestRequest>();

  List<HlaTestRequest> getCachedRequests() {
    try {
      return _requestBox.getAll();
    } catch (e, stack) {
      log(
        "Failed to read cached HLA requests",
        error: e,
        stackTrace: stack,
        name: "HLA Local Service",
      );
      throw AppException(
        message: "Failed to read cached requests",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    }
  }

  /// Replaces the cache with [requests] (keyed by uid via the unique index).
  void cacheRequests(List<HlaTestRequest> requests) {
    try {
      _requestBox.putMany(requests);
    } catch (e, stack) {
      log(
        "Failed to cache HLA requests",
        error: e,
        stackTrace: stack,
        name: "HLA Local Service",
      );
      throw AppException(
        message: "Failed to cache requests",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    }
  }

  void clear() {
    try {
      _requestBox.removeAll();
    } catch (e, stack) {
      log(
        "Failed to clear cached HLA requests",
        error: e,
        stackTrace: stack,
        name: "HLA Local Service",
      );
      throw AppException(
        message: "Failed to clear cached requests",
        debugMessage: e.toString(),
        stackTrace: stack,
        type: ExceptionType.localStorage,
      );
    }
  }
}
