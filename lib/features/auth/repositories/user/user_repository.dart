import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/core.dart';
import '../../auth.dart';
import '../../services/auth/remote/auth_service.dart';
import '../../services/user/local/user_local_service.dart';
import '../../services/user/remote/user_service.dart';

abstract class UserRepository {
  FutureEither<AppUser> getSelfUserData({bool forceRefresh = false});
  FutureEither<AppUser> updateUserData({
    required AppUser user,
    bool updateRemote = false,
  });
  FutureEither<AppUser> addUserData({
    required AppUser user,
    bool updateRemote = false,
  });
  FutureEither<void> deleteUserData({
    required AppUser user,
    bool deleteRemote = false,
  });
}

class UserRepositoryImpl implements UserRepository {
  final UserService _userService;
  final UserLocalService _userLocalService;
  final AuthService _authService;

  UserRepositoryImpl({
    required UserService userService,
    required UserLocalService userLocalService,
    required AuthService authService,
  }) : _authService = authService,
       _userLocalService = userLocalService,
       _userService = userService;

  @override
  FutureEither<AppUser> getSelfUserData({bool forceRefresh = false}) async {
    return futureHandler(() async {
      // Step 1: Check Firebase Authentication
      // First get from Firebase Auth in order to verify if the user is actually signed in before making any calls to remote;
      User? firebaseUser = await _authService.getFirebaseCurrentUser();

      if (firebaseUser == null) {
        // if user is not signed in, return an empty class
        log(
          "User is not signed in. Deleting local user data",
          name: "Firebase Auth",
        );
        _userLocalService.deleteUser();
        return AppUser.empty;
      }

      // Step 2: Force refresh from remote if requested
      if (forceRefresh) {
        log("Force refreshing from remote", name: "User Repository");
        AppUser user = await _userService.getUserData(firebaseUser.uid);
        return await _userLocalService.putAndGetUser(user);
      }

      // Step 3: Check local database for user data
      AppUser? localUser = _userLocalService.getUserByUid(firebaseUser.uid);
      if (localUser != null && localUser.isNotEmpty) {
        log("Local user found", name: "User Repository");
        return localUser;
      }
      // Step 4: Fetch remote user as fallback if local user is empty
      log(
        "Local user is empty. Attempting remote fetch...",
        name: "User Repository",
      );
      AppUser user = await _userService.getUserData(firebaseUser.uid);
      return await _userLocalService.putAndGetUser(user);
    });
  }

  @override
  FutureEither<AppUser> updateUserData({
    required AppUser user,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      if (updateRemote) {
        await _userService.updateUserData(user);
      }
      return await _userLocalService.putAndGetUser(user);
    });
  }

  @override
  FutureEither<AppUser> addUserData({
    required AppUser user,
    bool updateRemote = false,
  }) async {
    return futureHandler(() async {
      if (updateRemote) {
        await _userService.addUserData(user);
      }
      return await _userLocalService.putAndGetUser(user);
    });
  }

  /// --------- Delete User Data --------///
  @override
  FutureEither<void> deleteUserData({
    required AppUser user,
    bool deleteRemote = false,
  }) async {
    return futureHandler(() async {
      _userLocalService.deleteUser(user: user);
      if (deleteRemote) {
        await _userService.deleteUserData(user.uid);
      }
    });
  }
}
