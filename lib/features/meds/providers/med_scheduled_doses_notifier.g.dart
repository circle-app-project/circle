// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_scheduled_doses_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$medScheduledDosesNotifierHash() =>
    r'5b4b11117dca33568bdade9698180b0a759a734a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$MedScheduledDosesNotifier
    extends BuildlessAsyncNotifier<List<ScheduledDose>> {
  late final MedRepository medRepository;
  late final NotificationRepository notificationRepository;

  FutureOr<List<ScheduledDose>> build({
    required MedRepository medRepository,
    required NotificationRepository notificationRepository,
  });
}

/// See also [MedScheduledDosesNotifier].
@ProviderFor(MedScheduledDosesNotifier)
const medScheduledDosesNotifierProvider = MedScheduledDosesNotifierFamily();

/// See also [MedScheduledDosesNotifier].
class MedScheduledDosesNotifierFamily
    extends Family<AsyncValue<List<ScheduledDose>>> {
  /// See also [MedScheduledDosesNotifier].
  const MedScheduledDosesNotifierFamily();

  /// See also [MedScheduledDosesNotifier].
  MedScheduledDosesNotifierProvider call({
    required MedRepository medRepository,
    required NotificationRepository notificationRepository,
  }) {
    return MedScheduledDosesNotifierProvider(
      medRepository: medRepository,
      notificationRepository: notificationRepository,
    );
  }

  @override
  MedScheduledDosesNotifierProvider getProviderOverride(
    covariant MedScheduledDosesNotifierProvider provider,
  ) {
    return call(
      medRepository: provider.medRepository,
      notificationRepository: provider.notificationRepository,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'medScheduledDosesNotifierProvider';
}

/// See also [MedScheduledDosesNotifier].
class MedScheduledDosesNotifierProvider extends AsyncNotifierProviderImpl<
    MedScheduledDosesNotifier, List<ScheduledDose>> {
  /// See also [MedScheduledDosesNotifier].
  MedScheduledDosesNotifierProvider({
    required MedRepository medRepository,
    required NotificationRepository notificationRepository,
  }) : this._internal(
          () => MedScheduledDosesNotifier()
            ..medRepository = medRepository
            ..notificationRepository = notificationRepository,
          from: medScheduledDosesNotifierProvider,
          name: r'medScheduledDosesNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$medScheduledDosesNotifierHash,
          dependencies: MedScheduledDosesNotifierFamily._dependencies,
          allTransitiveDependencies:
              MedScheduledDosesNotifierFamily._allTransitiveDependencies,
          medRepository: medRepository,
          notificationRepository: notificationRepository,
        );

  MedScheduledDosesNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.medRepository,
    required this.notificationRepository,
  }) : super.internal();

  final MedRepository medRepository;
  final NotificationRepository notificationRepository;

  @override
  FutureOr<List<ScheduledDose>> runNotifierBuild(
    covariant MedScheduledDosesNotifier notifier,
  ) {
    return notifier.build(
      medRepository: medRepository,
      notificationRepository: notificationRepository,
    );
  }

  @override
  Override overrideWith(MedScheduledDosesNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MedScheduledDosesNotifierProvider._internal(
        () => create()
          ..medRepository = medRepository
          ..notificationRepository = notificationRepository,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        medRepository: medRepository,
        notificationRepository: notificationRepository,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<MedScheduledDosesNotifier, List<ScheduledDose>>
      createElement() {
    return _MedScheduledDosesNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MedScheduledDosesNotifierProvider &&
        other.medRepository == medRepository &&
        other.notificationRepository == notificationRepository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, medRepository.hashCode);
    hash = _SystemHash.combine(hash, notificationRepository.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MedScheduledDosesNotifierRef
    on AsyncNotifierProviderRef<List<ScheduledDose>> {
  /// The parameter `medRepository` of this provider.
  MedRepository get medRepository;

  /// The parameter `notificationRepository` of this provider.
  NotificationRepository get notificationRepository;
}

class _MedScheduledDosesNotifierProviderElement
    extends AsyncNotifierProviderElement<MedScheduledDosesNotifier,
        List<ScheduledDose>> with MedScheduledDosesNotifierRef {
  _MedScheduledDosesNotifierProviderElement(super.provider);

  @override
  MedRepository get medRepository =>
      (origin as MedScheduledDosesNotifierProvider).medRepository;
  @override
  NotificationRepository get notificationRepository =>
      (origin as MedScheduledDosesNotifierProvider).notificationRepository;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
