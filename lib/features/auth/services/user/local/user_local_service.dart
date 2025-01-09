import 'dart:developer';

import 'package:circle/objectbox.g.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../auth.dart';

///This app will eventually have multiple users, so it needs to be able to store multiple users

///Todo: Add try catches to all relevant local storage methods, with custom exceptions
class UserLocalService {
  late final Box<AppUser> _userBox;
  late final Box<UserProfile> _userProfileBox;

  UserLocalService({required Store store})
    : _userBox = store.box<AppUser>(),
      _userProfileBox = store.box<UserProfile>();

  // Stream<UserPreferences> listenUserPreferences() async* {
  //   yield* _userPreferencesBox
  //       .query()
  //       .watch(triggerImmediately: true)
  //       .map((query) => query.find().first);
  // }

  /// Attempts to get a user by id, returns null if a user doesn't exits
  AppUser? getUserById(int id) {
    try {
      return _userBox.get(id);
    } catch (e, stackTrace) {
      // Throws app exception
      log(
        "Failed to get user by id",
        error: e,
        stackTrace: stackTrace,
        name: "User Local Service",
      );
      throw AppException(
        message: "Failed to get user by id",
        debugMessage: e.toString(),
        stackTrace: stackTrace,
        type: ExceptionType.localStorage,
      );
    }
  }

  /// Attempts to get a user with this uid, returns null if a user doesn't exits
  AppUser? getUserByUid(String uid) {
    // Build the query to find the user with the specified UID
    late final Query<AppUser> query;
    try {
      // Find the first user matching the query
      query = _userBox.query(AppUser_.uid.equals(uid)).build();
      final List<AppUser> results = query.find();
      return results.isNotEmpty ? results.first : null;
    } catch (e, stackTrace) {
      // Throws app exception
      log(
        "Failed to get user by uid",
        error: e,
        stackTrace: stackTrace,
        name: "User Local Service",
      );
      throw AppException(
        message: "Failed to get user by uid",
        debugMessage: e.toString(),
        stackTrace: stackTrace,
        type: ExceptionType.localStorage,
      );
    } finally {
      // Ensure the query is always closed
      query.close();
    }
  }

  List<AppUser> getUsers() {
    try {
      return _userBox.getAll();
    } catch (e, stacktrace) {
      // Throws app exception
      log(
        "Failed to get users",
        error: e,
        stackTrace: stacktrace,
        name: "User Local Service",
      );
      throw AppException(
        message: "Failed to get users",
        debugMessage: e.toString(),
        stackTrace: stacktrace,
        type: ExceptionType.localStorage,
      );
    }
  }

  Future<AppUser> putAndGetUser(AppUser user) async {
    try {
      // Save relations first
      if (user.profile.target != null) {
        user.profile.target = await _userProfileBox.putAndGetAsync(
          user.profile.target!,
          mode: user.profile.target?.id == 0 ? PutMode.put : PutMode.update,
        );
      }

      // Then save user
      return await _userBox.putAndGetAsync(
        user,
        mode: user.id == 0 ? PutMode.put : PutMode.update,
      );
    } catch (e, stacktrace) {
      // Throws app exception
      log(
        "Failed to put and get user",
        error: e,
        stackTrace: stacktrace,
        name: "User Local Service",
      );
      throw AppException(
        message: "Failed to put and get user",
        debugMessage: e.toString(),
        stackTrace: stacktrace,
        type: ExceptionType.localStorage,
      );
    }
  }

  void deleteUser({AppUser? user}) {
    try {
      if (user == null) {
        _userProfileBox.removeAll();
        _userBox.removeAll();
      } else {
        if (user.profile.target?.id != null) {
          _userProfileBox.remove(user.profile.target!.id);
        }
        _userBox.remove(user.id);
      }
    } catch (e, stacktrace) {
      // Throws app exception
      log(
        "Failed to delete user",
        error: e,
        stackTrace: stacktrace,
        name: "User Local Service",
      );
      throw AppException(
        message: "Failed to delete",
        debugMessage: e.toString(),
        stackTrace: stacktrace,
        type: ExceptionType.localStorage,
      );
    }
  }
}
