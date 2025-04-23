// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_schedule_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$medScheduleNotifierHash() =>
    r'c7c91d94809a7b6c8dfa6f32f6d81ace98061c1a';

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

abstract class _$MedScheduleNotifier
    extends BuildlessAsyncNotifier<List<ScheduledDose>> {
  late final MedRepository medRepository;

  FutureOr<List<ScheduledDose>> build({
    required MedRepository medRepository,
  });
}

/// See also [MedScheduledDosesNotifier].
@ProviderFor(MedScheduledDosesNotifier)
const medScheduleNotifierProvider = MedScheduleNotifierFamily();

/// See also [MedScheduledDosesNotifier].
class MedScheduleNotifierFamily
    extends Family<AsyncValue<List<ScheduledDose>>> {
  /// See also [MedScheduledDosesNotifier].
  const MedScheduleNotifierFamily();

  /// See also [MedScheduledDosesNotifier].
  MedScheduledDosesNotifierProvider call({
    required MedRepository medRepository,
  }) {
    return MedScheduledDosesNotifierProvider(
      medRepository: medRepository,
    );
  }

  @override
  MedScheduledDosesNotifierProvider getProviderOverride(
    covariant MedScheduledDosesNotifierProvider provider,
  ) {
    return call(
      medRepository: provider.medRepository,
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
  String? get name => r'medScheduleNotifierProvider';
}

/// See also [MedScheduledDosesNotifier].
class MedScheduledDosesNotifierProvider extends AsyncNotifierProviderImpl<
    MedScheduledDosesNotifier, List<ScheduledDose>> {
  /// See also [MedScheduledDosesNotifier].
  MedScheduledDosesNotifierProvider({
    required MedRepository medRepository,
  }) : this._internal(
          () => MedScheduledDosesNotifier()..medRepository = medRepository,
          from: medScheduleNotifierProvider,
          name: r'medScheduleNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$medScheduleNotifierHash,
          dependencies: MedScheduleNotifierFamily._dependencies,
          allTransitiveDependencies:
              MedScheduleNotifierFamily._allTransitiveDependencies,
          medRepository: medRepository,
        );

  MedScheduledDosesNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.medRepository,
  }) : super.internal();

  final MedRepository medRepository;

  @override
  FutureOr<List<ScheduledDose>> runNotifierBuild(
    covariant MedScheduledDosesNotifier notifier,
  ) {
    return notifier.build(
      medRepository: medRepository,
    );
  }

  @override
  Override overrideWith(MedScheduledDosesNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MedScheduledDosesNotifierProvider._internal(
        () => create()..medRepository = medRepository,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        medRepository: medRepository,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<MedScheduledDosesNotifier, List<ScheduledDose>>
      createElement() {
    return _MedScheduleNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MedScheduledDosesNotifierProvider &&
        other.medRepository == medRepository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, medRepository.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MedScheduleNotifierRef on AsyncNotifierProviderRef<List<ScheduledDose>> {
  /// The parameter `medRepository` of this provider.
  MedRepository get medRepository;
}

class _MedScheduleNotifierProviderElement extends AsyncNotifierProviderElement<
    MedScheduledDosesNotifier, List<ScheduledDose>> with MedScheduleNotifierRef {
  _MedScheduleNotifierProviderElement(super.provider);

  @override
  MedRepository get medRepository =>
      (origin as MedScheduledDosesNotifierProvider).medRepository;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
