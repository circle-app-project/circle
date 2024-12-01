import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/core.dart';

import '../../auth.dart';
import '../../services/auth/remote/auth_service.dart';
import '../../services/user/local/user_local_service.dart';

/// The [AuthRepository] class provides an interface for managing authentication
/// and user-related operations. It bridges the gap between the [AuthService]
/// (handling Firebase operations) and the [UserLocalService] (handling local
/// database operations).
///
/// All methods return a [FutureEither] with a generic type.
///
/// [FutureEither] is just a type alias or typeDef for [Future<Either<Failure, T>>].
///
/// Handles the conversion of a [UserCredential] returned from [FirebaseAuth] to an [AppUser] object
/// and also handles saving the returned [AppUser] to the local database
class AuthRepository {
  final AuthService _authService;
  final UserLocalService _userLocalService;

  AuthRepository({
    required AuthService authService,
    required UserLocalService userLocalService,
  }) : _userLocalService = userLocalService,
       _authService = authService;

  FutureEither<AppUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return futureHandler(() async {
      final UserCredential userCredential = await _authService
          .signInWithEmailAndPassword(email: email, password: password);

      return await _handleUserCredential(userCredential);
    });
  }

  FutureEither<AppUser?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return futureHandler(() async {
      final UserCredential userCredential = await _authService
          .registerWithEmailAndPassword(email: email, password: password);
      return await _handleUserCredential(userCredential);
    });
  }

  FutureEither<AppUser> signInWithGoogle() {
    return futureHandler(() async {
      final UserCredential userCredential =
          await _authService.signInWithGoogle();
      return await _handleUserCredential(userCredential);
    });
  }

  FutureEither<void> signOut() {
    return futureHandler(() async {
      _userLocalService.deleteUser();
      await _authService.signOut();
    });
  }

  Stream<AppUser> getAuthStateChanges() {
    return _authService.authStateChanges().map((User? user) {
      if (user == null) {
        return AppUser.empty;
      }
      return AppUser.fromUser(
        user: user,
      ).copyWith(profile: UserProfile.fromFirebaseUser(user: user));
    });
  }

  FutureEither<void> sendPasswordResetEmail({required String email}) async {
    return futureHandler(() async {
      await _authService.sendPasswordResetEmail(email: email);
    });
  }

  FutureEither<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    return futureHandler(() async {
      await _authService.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
    });
  }

  /// Handles a [UserCredential] from Firebase Authentication
  /// by converting to an [AppUser] object
  ///
  /// Adds a new [AppUser] To the local database if it does not already exist
  ///
  /// If a user with the same UID already exists, updates the existing user while
  /// making sure to update only the relevant fields from [UserProfile.fromFirebaseUser]
  /// instead of overriding the entire [UserProfile] with empty values by
  /// copying over just the non empty values from the updated [UserProfile]
  /// into the existing UserProfile
  Future<AppUser> _handleUserCredential(UserCredential userCredential) async {
    // Create a new user object from the Firebase user
    AppUser newUser = AppUser.fromUser(user: userCredential.user);
    newUser = newUser.copyWith(
      profile: UserProfile.fromFirebaseUser(user: userCredential.user),
      preferences: UserPreferences.empty.copyWith(
        uid: userCredential.user?.uid,
      ),
    );

    // Check if a user with this UID already exists in the local database
    AppUser? existingUser = _userLocalService.getUserByUid(newUser.uid);

    if (existingUser == null) {
      // If no existing user, simply add the new user
      // Making sure to assign the new id from object box to the user
      return await _userLocalService.putAndGetUser(newUser);

    }
    // If user exists, update the existing user
    // Also updates only the relevant fields from the UserCredential object
    UserProfile updatedUserProfile = UserProfile.fromFirebaseUser(
      user: userCredential.user,
    );
    AppUser updatedUser = existingUser.copyWith(
      profile: existingUser.profile.target?.copyWith(
        uid: userCredential.user?.uid,
        name: updatedUserProfile.name,
        email: updatedUserProfile.email,
        photoUrl: updatedUserProfile.photoUrl,
        displayName: updatedUserProfile.displayName,
      ),
      preferences: existingUser.preferences.target?.copyWith(
        uid: userCredential.user?.uid,
      ),
    );
    return await _userLocalService.putAndGetUser(updatedUser);
  }
}
