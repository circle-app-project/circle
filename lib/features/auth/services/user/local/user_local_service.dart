import 'dart:developer';

import 'package:circle/objectbox.g.dart';

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
    return _userBox.get(id);
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
        name: "User Service",
      );
      //Todo: throw exception
      // throw AppException(
      //   message: "Failed to get user by uid",
      //   debugMessage: e.toString(),
      //   stackTrace: stackTrace,
      //   type: ExceptionType.localStorage,
      // );
    }
    finally {
      // Ensure the query is always closed
      query.close();
    }
    return null;
  }

  List<AppUser> getUsers() {
    return _userBox.getAll();
  }

  Future<AppUser> putAndGetUser(AppUser user) async {
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
  }

  void deleteUser({AppUser? user}) {
    if (user == null) {
      _userProfileBox.removeAll();
      _userBox.removeAll();
    } else {
      if (user.profile.target?.id != null) {
        _userProfileBox.remove(user.profile.target!.id);
      }
      _userBox.remove(user.id);
    }
  }
}
