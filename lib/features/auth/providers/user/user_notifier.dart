import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/core.dart';
import '../../auth.dart';


class UserNotifier extends AsyncNotifier<AppUser> {
  final UserRepository _userRepository;
  UserNotifier({required UserRepository userRepository})
      : _userRepository = userRepository;

  ///Getter to actually know when an operation is successful or not;
  ///Getters to actually know when an operation is successful or not;
  bool get isSuccessful =>
      state.hasValue &&
      state.value != null &&
      state.value!.isNotEmpty &&
      !state.hasError;

  String? get errorMessage => state.error is Failure
      ? (state.error as Failure).message
      : state.error.toString();

  @override
  Future<AppUser> build() async {
    return AppUser.empty;
  }

  void saveDataToState(AppUser user) {
    state = AsyncValue.data(user);
  }

  Future<void> getCurrentUserData({bool forceRefresh = false}) async {
    state = const AsyncValue.loading();
    final Either<Failure, AppUser> response =
        await _userRepository.getCurrentUserData(forceRefresh: forceRefresh);
    response.fold((failure) {
      state = AsyncValue.error(failure, failure.stackTrace!);
    }, (user) {
      state = AsyncValue.data(user);
    });
  }

  /// Puts User Data
  /// If data exists, it will be updated, if not, it will be added and the updated data with the new id from object box will be returned and set to stata
  Future<void> putUserData(
      {required AppUser user, bool updateRemote = false}) async {
   // log("ADDING USER DATA TO LOCAL DB", name: "USER NOTIFIER");
    log("PUTTING USER DATA TO LOCAL DB", name: "USER NOTIFIER");
    state = const AsyncValue.loading();
    final Either<Failure, AppUser> response = await _userRepository.addUserData(
        user: user, updateRemote: updateRemote);
    response.fold((failure) {
      log("RETURNED FAILURE", name: "USER NOTIFIER", stackTrace: failure.stackTrace);
      state = AsyncValue.error(failure, failure.stackTrace!);
    }, (user) {

      log("RETURNED SUCCESS", name: "USER NOTIFIER");
      print("verifying retruned id after putting data is actually updated");

      print( user.id);
      //Set the state to be equal to the data that was just added
      state = AsyncValue.data(user);
    });
  }

  @Deprecated("Prefer putUserData instead")
  Future<void> updateUserData(
      {required AppUser user, bool updateRemote = false}) async {
    log("Updating User Data", name: "USER NOTIFIER");
    state = const AsyncValue.loading();
    final Either<Failure, AppUser> response = await _userRepository.updateUserData(
        user: user, updateRemote: updateRemote);
    response.fold((failure) {
      log("RETURNED FAILURE", name: "USER NOTIFIER", stackTrace: failure.stackTrace);
      state = AsyncValue.error(failure, failure.stackTrace!);
    }, (user) {
      log("RETURNED SUCCESS", name: "USER NOTIFIER");
      //Set the state to be equal to the data that was just added
      state = AsyncValue.data(user);
    });
  }

  Future<void> deleteUserData(
      {required AppUser user, bool updateRemote = false}) async {
    state = const AsyncValue.loading();
    final Either<Failure, void> response = await _userRepository.deleteUserData(
        user: user, deleteRemote: updateRemote);
    response.fold((failure) {
      log("RETURNED FAILURE", name: "USER NOTIFIER", stackTrace: failure.stackTrace);
      state = AsyncValue.error(failure, failure.stackTrace!);
    }, (empty) {
      state = AsyncValue.data(AppUser.empty);
    });
  }
}
