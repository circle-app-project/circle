import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/core.dart';
import '../../../../main.dart';
import '../../auth.dart';
import '../../services/user/local/user_local_service.dart';
import '../../services/user/remote/user_service.dart';

part 'user_notifier.g.dart';

final UserService userService = UserService();
final UserLocalService userLocalService = UserLocalService(
  store: database.store,
);
final UserRepository _userRepository = UserRepositoryImpl(
  userLocalService: userLocalService,
  userService: userService,
  authService: authService,
);

final UserNotifierProvider userNotifierProviderImpl = userNotifierProvider(
  userRepository: _userRepository,
);

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  late final UserRepository _userRepository;

  ///Getter to actually know when an operation is successful or not;
  @Deprecated("Prefer using ref.watch(userProvider) instead")
  bool get isSuccessful =>
      state.hasValue &&
      state.value != null &&
      state.value!.isNotEmpty &&
      !state.hasError;

  @Deprecated("Prefer moving this to snack bar widget")
  String? get errorMessage =>
      state.error is Failure
          ? (state.error as Failure).message
          : state.error.toString();

  @override
  FutureOr<AppUser> build({required UserRepository userRepository}) async {
    _userRepository = userRepository;
    return AppUser.empty;
  }

  void saveDataToState(AppUser user) {
    state = AsyncValue.data(user);
  }

  Future<void> getSelfUserData({bool forceRefresh = false}) async {
    log("Getting Self User Data", name: "User Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, AppUser> response = await _userRepository
        .getSelfUserData(forceRefresh: forceRefresh);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "User Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (user) {
        state = AsyncValue.data(user);
        log("Success ${state.value}", name: "User Notifier");
      },
    );
  }

  /// Puts User Data
  /// If data exists, it will be updated, if not, it will be added
  /// nd the updated data with the new id from object box will be returned and set to stata
  Future<void> putUserData({
    required AppUser user,
    bool updateRemote = false,
  }) async {
    log("Putting User Data", name: "User Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, AppUser> response = await _userRepository.addUserData(
      user: user,
      updateRemote: updateRemote,
    );
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "User Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (user) {
        //Set the state to be equal to the data that was just added
        state = AsyncValue.data(user);
        log("Success ${state.value}", name: "User Notifier");
      },
    );
  }

  @Deprecated("Prefer putUserData instead")
  Future<void> updateUserData({
    required AppUser user,
    bool updateRemote = false,
  }) async {
    log("Updating User Data", name: "User Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, AppUser> response = await _userRepository
        .updateUserData(user: user, updateRemote: updateRemote);
    response.fold(
      (failure) {
        state = AsyncValue.error(failure, failure.stackTrace!);
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "User Notifier",
          stackTrace: failure.stackTrace,
        );
      },
      (user) {
        state = AsyncValue.data(user);
        log("Success ${state.value}", name: "User Notifier");
      },
    );
  }

  Future<void> deleteUserData({
    required AppUser user,
    bool updateRemote = false,
  }) async {
    log("Deleting User Data", name: "User Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _userRepository.deleteUserData(
      user: user,
      deleteRemote: updateRemote,
    );
    response.fold(
      (failure) {
        log(
          "Failed: $failure, Message:${failure.message}, Code: ${failure.code}",
          name: "User Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(failure, failure.stackTrace!);
      },
      (empty) {
        state = AsyncValue.data(AppUser.empty);
        log("Success: ${state.value}", name: "User Notifier");
      },
    );
  }
}
