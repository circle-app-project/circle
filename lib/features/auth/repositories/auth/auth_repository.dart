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
abstract class AuthRepository {
  FutureEither<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  FutureEither<AppUser> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  FutureEither<AppUser> signInWithGoogle();

  FutureEither<void> signOut();

  Stream<AppUser> getAuthStateChanges();

  FutureEither<void> sendPasswordResetEmail({required String email});

  FutureEither<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  final UserLocalService _userLocalService;

  AuthRepositoryImpl({
    required AuthService authService,
    required UserLocalService userLocalService,
  }) : _userLocalService = userLocalService,
       _authService = authService;

  @override
  FutureEither<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return futureHandler(() async {
      final UserCredential userCredential = await _authService
          .signInWithEmailAndPassword(email: email, password: password);

      return await _handleUserCredential(userCredential);
    });
  }

  @override
  FutureEither<AppUser> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return futureHandler(() async {
      final UserCredential userCredential = await _authService
          .registerWithEmailAndPassword(email: email, password: password);
      return await _handleUserCredential(userCredential);
    });
  }

  @override
  FutureEither<AppUser> signInWithGoogle() {
    return futureHandler(() async {
      final UserCredential userCredential =
          await _authService.signInWithGoogle();
      return await _handleUserCredential(userCredential);
    });
  }

  @override
  FutureEither<void> signOut() {
    return futureHandler(() async {
      _userLocalService.deleteUser();
      await _authService.signOut();
    });
  }

  @override
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

  @override
  FutureEither<void> sendPasswordResetEmail({required String email}) async {
    return futureHandler(() async {
      await _authService.sendPasswordResetEmail(email: email);
    });
  }

  @override
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
    // Create a new AppUser object from the Firebase user
    AppUser newUser = AppUser.fromUser(user: userCredential.user);
    newUser = newUser.copyWith(
      profile: UserProfile.fromFirebaseUser(user: userCredential.user)
    );

    // Fetch existing user by UID from the local database
    AppUser? existingUser = _userLocalService.getUserByUid(newUser.uid);

    if (existingUser == null) {
      // No existing user, add the new user
      return await _userLocalService.putAndGetUser(newUser);
    }

    // Update only non-empty fields of the existing user's profile
    UserProfile existingProfile =
        existingUser.profile.target ?? UserProfile.empty;
    UserProfile updatedProfile = existingProfile.copyWith(
      uid: userCredential.user?.uid,
      name:
          userCredential.user?.displayName?.isNotEmpty == true
              ? userCredential.user?.displayName
              : existingProfile.name,
      email:
          userCredential.user?.email?.isNotEmpty == true
              ? userCredential.user?.email
              : existingProfile.email,
      photoUrl:
          userCredential.user?.photoURL?.isNotEmpty == true
              ? userCredential.user?.photoURL
              : existingProfile.photoUrl,
      displayName:
          userCredential.user?.displayName?.isNotEmpty == true
              ? userCredential.user?.displayName
              : existingProfile.displayName,
    );

    // Update the existing user with the updated profile and preferences
    AppUser updatedUser = existingUser.copyWith(
      profile: updatedProfile,
    );

    // Save the updated user back to the database
    return await _userLocalService.putAndGetUser(updatedUser);
  }
}
