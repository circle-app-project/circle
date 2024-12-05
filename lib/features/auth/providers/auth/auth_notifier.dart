import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/core.dart';
import '../../auth.dart';

class AuthNotifier extends AsyncNotifier<AppUser?> {
  final AuthRepository _authRepository;

  AuthNotifier({required AuthRepository authRepository})
    : _authRepository = authRepository;

  ///Getters to actually know when an operation is successful or not;
  bool get isSuccessful =>
      state.hasValue &&
          state.value != null &&
          !state.hasError &&
          (state.value is! AppUser || (state.value as AppUser).isNotEmpty);


  String? get errorMessage =>
      state.error is Failure
          ? (state.error as Failure).message
          : state.error.toString();

  @override
  Future<AppUser> build() async {
    return AppUser.empty;
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    log("SIGNING IN WITH EMAIL", name: "AUTH NOTIFIER");
    state = const AsyncValue.loading();
    final Either<Failure, AppUser?> response = await _authRepository
        .signInWithEmailAndPassword(email: email, password: password);

    response.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        log("FAILED", name: "AUTH NOTIFIER", stackTrace: failure.stackTrace);
      },
      (user) async {
      //  await ref.watch(userProvider.notifier).getSelfUserData();
        state = AsyncValue.data(user);
        log("SUCCESS", name: "AUTH NOTIFIER");
      },
    );
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    log("REGISTERING IN WITH EMAIL", name: "AUTH NOTIFIER");
    state = const AsyncValue.loading();
    final Either<Failure, AppUser?> response = await _authRepository
        .registerWithEmailAndPassword(email: email, password: password);

    response.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        log("FAILED", name: "AUTH NOTIFIER", stackTrace: failure.stackTrace);
      },
      (user) async {
        state = AsyncValue.data(user);
        log("SUCCESS", name: "AUTH NOTIFIER");
      },
    );
  }

  Future<void> singInWithGoogle() async {
    log("SIGNING IN WITH GOOGLE", name: "AUTH NOTIFIER");

    state = const AsyncValue.loading();
    final Either<Failure, AppUser?> response =
        await _authRepository.signInWithGoogle();

    response.fold(
      (failure) {
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
        log("FAILED", name: "AUTH NOTIFIER", stackTrace: failure.stackTrace);
      },
      (user) async {
        state = AsyncValue.data(user);
        log("SUCCESS", name: "AUTH NOTIFIER");
      },
    );
  }

  Future<void> signOut() async {
    log("SIGNING OUT", name: "AUTH NOTIFIER");

    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _authRepository.signOut();

    response.fold(
      (failure) {
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
        log("FAILED", name: "AUTH NOTIFIER", stackTrace: failure.stackTrace);
      },
      (empty) async {
        state = AsyncValue.data(AppUser.empty);
        log("SUCCESS", name: "AUTH NOTIFIER");
      },
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    log("REQUESTING PASSWORD RESET EMAIL", name: "AUTH NOTIFIER");

    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _authRepository
        .sendPasswordResetEmail(email: email);

    response.fold(
      (failure) {
        log("FAILED", name: "AUTH NOTIFIER", stackTrace: failure.stackTrace);
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (empty) async {
        state = AsyncValue.data(AppUser.empty);
        log("SUCCESS", name: "AUTH NOTIFIER");
      },
    );
  }

  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    log("CONFIRMING PASSWORD RESET", name: "AUTH NOTIFIER");
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _authRepository
        .confirmPasswordReset(code: code, newPassword: newPassword);

    response.fold(
      (failure) {
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
        log("FAILED", name: "AUTH NOTIFIER", stackTrace: failure.stackTrace);
      },
      (empty) async {
        state = AsyncValue.data(AppUser.empty);
        log("SUCCESS", name: "AUTH NOTIFIER");
      },
    );
  }

  Stream<AppUser> authStateChanges() {
    final Stream<AppUser> userStream = _authRepository.getAuthStateChanges();

    userStream
        .listen((event) {
          state = AsyncValue.data(event);
        })
        .onError((error) {
          state = AsyncValue.error(error, StackTrace.current);
        });

    return userStream;
  }
}
