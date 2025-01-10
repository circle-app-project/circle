import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/core.dart';
import '../../auth.dart';
import '../../services/auth/remote/auth_service.dart';
import '../../services/user/local/user_local_service.dart';
import '../../services/user/remote/user_service.dart';

abstract class UserRepository {
  FutureEither<AppUser> getSelfUserData({bool forceRefresh = false});

  ///Todo: Move this logic to the User Service for clear seperations of concerns
  Future<AppUser> _getRemoteUser(String uid);

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
      log("GETTING SELF USER", name: "USER REPOSITORY");

      // Step 1: Check Firebase Authentication
      // First get from Firebase Auth in order to verify if the user is actually signed in before making any calls to remote;
      User? firebaseUser = await _authService.getFirebaseCurrentUser();

      if (firebaseUser == null) {
        // f user is not signed in, return an empty class
        log(
          "USER IS NOT SIGNED IN. Deleting local user data",
          name: "FIREBASE AUTH",
        );
        _userLocalService.deleteUser();
        return AppUser.empty;
      }

      // Step 2: Force refresh from remote if requested
      if (forceRefresh) {
        log("FORCE REFRESHING FROM REMOTE", name: "USER REPOSITORY");
        return await _getRemoteUser(firebaseUser.uid);
      }

      // Step 3: Check local database for user data
      AppUser? localUser = _userLocalService.getUserByUid(firebaseUser.uid);
      if (localUser != null && localUser.isNotEmpty) {
        log("LOCAL USER FOUND", name: "USER LOCAL SERVICE");
        return localUser;
      }

      // Step 4: Fetch remote user as fallback if local user is empty
      log(
        "LOCAL USER IS EMPTY. Attempting remote fetch...",
        name: "USER REPOSITORY",
      );
      return await _getRemoteUser(firebaseUser.uid);
    });
  }

  ///Todo: Move this logic to the User Service for clear seperations of concerns
  @override
  Future<AppUser> _getRemoteUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _userService
        .getUserData(uid);

    if (documentSnapshot.exists &&
        documentSnapshot.data() != null &&
        documentSnapshot.data()!.isNotEmpty) {
      AppUser remoteUser = AppUser.fromMap(data: documentSnapshot.data()!);
      await _userLocalService.putAndGetUser(remoteUser);
      return remoteUser;
    } else {
      log(
        "FAILED TO FETCH REMOTE USER: USER DATA DOESN'T EXIST",
        name: "USER REPOSITORY",
      );
      _userLocalService.deleteUser();
      return AppUser.empty;
    }
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
