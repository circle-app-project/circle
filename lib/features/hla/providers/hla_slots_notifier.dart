import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/core.dart';
import '../hla.dart';

part 'hla_slots_notifier.g.dart';

final HlaSlotsNotifierProvider hlaSlotsNotifierProviderImpl =
    hlaSlotsNotifierProvider(hlaRepository: hlaRepository);

/// Loads the bookable appointment slots a patient can choose from (future,
/// active, not full).
@Riverpod(keepAlive: true)
class HlaSlotsNotifier extends _$HlaSlotsNotifier {
  late final HlaRepository _hlaRepository;

  @override
  FutureOr<List<HlaAppointmentSlot>> build({
    required HlaRepository hlaRepository,
  }) async {
    _hlaRepository = hlaRepository;
    return [];
  }

  Future<void> getAvailableSlots() async {
    log("Getting available slots", name: "HLA Slots Notifier");
    state = const AsyncValue.loading();
    final Either<Failure, List<HlaAppointmentSlot>> response =
        await _hlaRepository.getAvailableSlots();
    response.fold(
      (failure) {
        log(
          "Failed to get slots: ${failure.message}, code: ${failure.code}",
          name: "HLA Slots Notifier",
          stackTrace: failure.stackTrace,
        );
        state = AsyncValue.error(
          failure,
          failure.stackTrace ?? StackTrace.current,
        );
      },
      (slots) {
        log("Loaded ${slots.length} slot(s)", name: "HLA Slots Notifier");
        state = AsyncValue.data(slots);
      },
    );
  }
}
