import 'dart:async';
import 'dart:developer';
import 'package:circle/features/auth/services/user/local/user_local_service.dart';
import 'package:circle/main.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/core.dart';
import '../../auth.dart';
import '../../services/auth/remote/auth_service.dart';

part 'auth_notifier.g.dart';

final AuthService authService = AuthService();
final AuthRepository _authRepository = AuthRepositoryImpl(
  userLocalService: UserLocalService(store: database.store),
  authService: authService,
);

final AuthNotifierProvider authNotifierProviderIml = authNotifierProvider(
  authRepository: _authRepository,
);

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  late final AuthRepository _authRepository;

  ///Getters to actually know when an operation is successful or not;

  @Deprecated("Deprecated, Prefer using !ref.watch(authProvider).hasError")
  bool get isSuccessful =>
      state.hasValue &&
      state.value != null &&
      !state.hasError &&
      (state.value is! AppUser || (state.value as AppUser).isNotEmpty);

  @Deprecated(
    "Probably move this to the custom snack bar... Deprecating for now",
  )
  String? get errorMessage =>
      state.error is Failure
          ? (state.error as Failure).message
          : state.error.toString();

  @override
  FutureOr<AppUser> build({required AuthRepository authRepository}) async {
    _authRepository = authRepository;
    return AppUser.empty;
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    log("SIGNING IN WITH EMAIL", name: "Auth Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, AppUser> response = await _authRepository
        .signInWithEmailAndPassword(email: email, password: password);

    response.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Auth Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (user) async {
        //  await ref.watch(userProvider.notifier).getSelfUserData();
        state = AsyncValue.data(user);
        log("Success ${state.value}", name: "Auth Notifier");
      },
    );
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    log("REGISTERING IN WITH EMAIL", name: "Auth Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, AppUser> response = await _authRepository
        .registerWithEmailAndPassword(email: email, password: password);

    response.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Auth Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (user) async {
        state = AsyncValue.data(user);
        log("Success ${state.value}", name: "Auth Notifier");
      },
    );
  }

  Future<void> singInWithGoogle() async {
    log("SIGNING IN WITH GOOGLE", name: "Auth Notifier");

    state = const AsyncValue.loading();
    final Either<Failure, AppUser> response =
        await _authRepository.signInWithGoogle();

    response.fold(
      (failure) {
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Auth Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (user) async {
        state = AsyncValue.data(user);
        log("Success ${state.value}", name: "Auth Notifier");
      },
    );
  }

  Future<void> signOut() async {
    log("SIGNING OUT", name: "Auth Notifier");

    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _authRepository.signOut();

    response.fold(
      (failure) {
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Auth Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (empty) async {
        state = AsyncValue.data(AppUser.empty);
        log("Success ${state.value}", name: "Auth Notifier");
      },
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    log("REQUESTING PASSWORD RESET EMAIL", name: "Auth Notifier");

    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _authRepository
        .sendPasswordResetEmail(email: email);

    response.fold(
      (failure) {
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Auth Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (empty) async {
        state = AsyncValue.data(AppUser.empty);
        log("Success ${state.value}", name: "Auth Notifier");
      },
    );
  }

  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    log("CONFIRMING PASSWORD RESET", name: "Auth Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _authRepository
        .confirmPasswordReset(code: code, newPassword: newPassword);

    response.fold(
      (failure) {
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "Auth Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (empty) async {
        state = AsyncValue.data(AppUser.empty);
        log("Success ${state.value}", name: "Auth Notifier");
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
