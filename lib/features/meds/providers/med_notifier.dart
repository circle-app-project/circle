import 'dart:developer';

import 'package:circle/features/auth/auth.dart';
import 'package:circle/features/meds/repositories/med_repository.dart';
import 'package:circle/features/meds/services/local/med_local_service.dart';
import 'package:circle/features/meds/services/remote/med_service.dart';
import 'package:circle/main.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/failure.dart';
import '../models/medication.dart';
part 'med_notifier.g.dart';

final MedService medService = MedService();
final MedLocalService medLocalService = MedLocalService(store: database.store);
final MedRepository _medRepository = MedRepositoryImpl(
  medService: medService,
  medLocalService: medLocalService,
);

final MedNotifierProvider medNotifierProviderImpl = MedNotifierProvider(
  medRepository: _medRepository,
);

@Riverpod(keepAlive: true)
class MedNotifier extends _$MedNotifier {
  late final MedRepository _medRepository;
  late final AppUser? user;

  @override
  FutureOr<List<Medication>> build({
    required MedRepository medRepository,
  }) async {
    _medRepository = medRepository;
    user = ref.watch(userNotifierProviderImpl).value;

    return [];
  }

  Future<void> getMedications({bool forceRefresh = false}) async {
    log("Getting Self User Data", name: "User Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, List<Medication>> response = await _medRepository
        .getAllMedications(user: user!);
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
}
