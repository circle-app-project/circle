import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/core.dart';
import '../../auth.dart';
import '../../services/auth/remote/auth_service.dart';
import '../../services/user/local/user_local_service.dart';
import '../../services/user/remote/user_service.dart';

class UserRepository {
  final UserService _userService;
  final UserLocalService _userLocalService;
  final AuthService _authService;

  UserRepository({
    required UserService userService,
    required UserLocalService userLocalService,
    required AuthService authService,
  }) : _authService = authService,
       _userLocalService = userLocalService,
       _userService = userService;

  FutureEither<AppUser> getCurrentUserData({bool forceRefresh = false}) async {
    return futureHandler(() async {
      ///First get from Firebase Auth in order to verify if the user is actually signed in before making any calls to remote;

      User? currentUser = await _authService.getCurrentUser();

      if (currentUser == null) {
        ///If user is not signed in, return an empty class
        log("USER IS NOT SIGNED IN", name: "FIREBASE AUTH");
        _userLocalService.deleteUser();
        return AppUser.empty;
      }

      if (forceRefresh) {
        log("FORCE REFRESHING FROM REMOTE", name: "USER REPOSITORY");
        return await _getRemoteUser(currentUser.uid);
      }

      AppUser localUser = _userLocalService.getUser();
      if (localUser.isNotEmpty) {
        log("LOCAL USER FOUND", name: "USER LOCAL SERVICE");
        return localUser;
      } else {
        log("LOCAL USER IS EMPTY", name: "USER LOCAL SERVICE");
        _userLocalService.deleteUser();
        return AppUser.empty;
      }
    });
  }

  Future<AppUser> _getRemoteUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _userService
        .getUserData(uid);

    if (documentSnapshot.exists &&
        documentSnapshot.data() != null &&
        documentSnapshot.data()!.isNotEmpty) {
      AppUser remoteUser = AppUser.fromMap(data: documentSnapshot.data()!);
      _userLocalService.putAndGetUser(remoteUser);
      return remoteUser;
    } else {
      throw Exception("User data doesn't exist");
    }
  }

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
