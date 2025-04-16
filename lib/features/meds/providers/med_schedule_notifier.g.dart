// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_schedule_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$medScheduleNotifierHash() =>
    r'ae998a2e39da0dd495e481a0881aa05120896f1a';

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
    extends BuildlessAsyncNotifier<List<MedSchedule>> {
  late final MedRepository medRepository;

  FutureOr<List<MedSchedule>> build({
    required MedRepository medRepository,
  });
}

/// See also [MedScheduleNotifier].
@ProviderFor(MedScheduleNotifier)
const medScheduleNotifierProvider = MedScheduleNotifierFamily();

/// See also [MedScheduleNotifier].
class MedScheduleNotifierFamily extends Family<AsyncValue<List<MedSchedule>>> {
  /// See also [MedScheduleNotifier].
  const MedScheduleNotifierFamily();

  /// See also [MedScheduleNotifier].
  MedScheduleNotifierProvider call({
    required MedRepository medRepository,
  }) {
    return MedScheduleNotifierProvider(
      medRepository: medRepository,
    );
  }

  @override
  MedScheduleNotifierProvider getProviderOverride(
    covariant MedScheduleNotifierProvider provider,
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

/// See also [MedScheduleNotifier].
class MedScheduleNotifierProvider
    extends AsyncNotifierProviderImpl<MedScheduleNotifier, List<MedSchedule>> {
  /// See also [MedScheduleNotifier].
  MedScheduleNotifierProvider({
    required MedRepository medRepository,
  }) : this._internal(
          () => MedScheduleNotifier()..medRepository = medRepository,
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

  MedScheduleNotifierProvider._internal(
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
  FutureOr<List<MedSchedule>> runNotifierBuild(
    covariant MedScheduleNotifier notifier,
  ) {
    return notifier.build(
      medRepository: medRepository,
    );
  }

  @override
  Override overrideWith(MedScheduleNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MedScheduleNotifierProvider._internal(
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
  AsyncNotifierProviderElement<MedScheduleNotifier, List<MedSchedule>>
      createElement() {
    return _MedScheduleNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MedScheduleNotifierProvider &&
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
mixin MedScheduleNotifierRef on AsyncNotifierProviderRef<List<MedSchedule>> {
  /// The parameter `medRepository` of this provider.
  MedRepository get medRepository;
}

class _MedScheduleNotifierProviderElement
    extends AsyncNotifierProviderElement<MedScheduleNotifier, List<MedSchedule>>
    with MedScheduleNotifierRef {
  _MedScheduleNotifierProviderElement(super.provider);

  @override
  MedRepository get medRepository =>
      (origin as MedScheduleNotifierProvider).medRepository;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
