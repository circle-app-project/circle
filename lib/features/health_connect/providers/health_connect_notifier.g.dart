// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_connect_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$healthPermissionNotifierHash() =>
    r'd3c27e05a3455ce83a41664ec42a50bd0368fe7e';

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

abstract class _$HealthPermissionNotifier
    extends BuildlessAsyncNotifier<HealthPermissionStatus> {
  late final HealthRepository healthRepository;

  FutureOr<HealthPermissionStatus> build({
    required HealthRepository healthRepository,
  });
}

/// Holds the Health Connect permission state, kept separate from the data
/// notifier because permission and data have different lifecycles.
///
/// Copied from [HealthPermissionNotifier].
@ProviderFor(HealthPermissionNotifier)
const healthPermissionNotifierProvider = HealthPermissionNotifierFamily();

/// Holds the Health Connect permission state, kept separate from the data
/// notifier because permission and data have different lifecycles.
///
/// Copied from [HealthPermissionNotifier].
class HealthPermissionNotifierFamily
    extends Family<AsyncValue<HealthPermissionStatus>> {
  /// Holds the Health Connect permission state, kept separate from the data
  /// notifier because permission and data have different lifecycles.
  ///
  /// Copied from [HealthPermissionNotifier].
  const HealthPermissionNotifierFamily();

  /// Holds the Health Connect permission state, kept separate from the data
  /// notifier because permission and data have different lifecycles.
  ///
  /// Copied from [HealthPermissionNotifier].
  HealthPermissionNotifierProvider call({
    required HealthRepository healthRepository,
  }) {
    return HealthPermissionNotifierProvider(healthRepository: healthRepository);
  }

  @override
  HealthPermissionNotifierProvider getProviderOverride(
    covariant HealthPermissionNotifierProvider provider,
  ) {
    return call(healthRepository: provider.healthRepository);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'healthPermissionNotifierProvider';
}

/// Holds the Health Connect permission state, kept separate from the data
/// notifier because permission and data have different lifecycles.
///
/// Copied from [HealthPermissionNotifier].
class HealthPermissionNotifierProvider
    extends
        AsyncNotifierProviderImpl<
          HealthPermissionNotifier,
          HealthPermissionStatus
        > {
  /// Holds the Health Connect permission state, kept separate from the data
  /// notifier because permission and data have different lifecycles.
  ///
  /// Copied from [HealthPermissionNotifier].
  HealthPermissionNotifierProvider({required HealthRepository healthRepository})
    : this._internal(
        () => HealthPermissionNotifier()..healthRepository = healthRepository,
        from: healthPermissionNotifierProvider,
        name: r'healthPermissionNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$healthPermissionNotifierHash,
        dependencies: HealthPermissionNotifierFamily._dependencies,
        allTransitiveDependencies:
            HealthPermissionNotifierFamily._allTransitiveDependencies,
        healthRepository: healthRepository,
      );

  HealthPermissionNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.healthRepository,
  }) : super.internal();

  final HealthRepository healthRepository;

  @override
  FutureOr<HealthPermissionStatus> runNotifierBuild(
    covariant HealthPermissionNotifier notifier,
  ) {
    return notifier.build(healthRepository: healthRepository);
  }

  @override
  Override overrideWith(HealthPermissionNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: HealthPermissionNotifierProvider._internal(
        () => create()..healthRepository = healthRepository,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        healthRepository: healthRepository,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<HealthPermissionNotifier, HealthPermissionStatus>
  createElement() {
    return _HealthPermissionNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HealthPermissionNotifierProvider &&
        other.healthRepository == healthRepository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, healthRepository.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HealthPermissionNotifierRef
    on AsyncNotifierProviderRef<HealthPermissionStatus> {
  /// The parameter `healthRepository` of this provider.
  HealthRepository get healthRepository;
}

class _HealthPermissionNotifierProviderElement
    extends
        AsyncNotifierProviderElement<
          HealthPermissionNotifier,
          HealthPermissionStatus
        >
    with HealthPermissionNotifierRef {
  _HealthPermissionNotifierProviderElement(super.provider);

  @override
  HealthRepository get healthRepository =>
      (origin as HealthPermissionNotifierProvider).healthRepository;
}

String _$healthSummaryNotifierHash() =>
    r'cce14160c3805569e37eb875e2c38ef48599b89e';

abstract class _$HealthSummaryNotifier
    extends BuildlessAsyncNotifier<HealthSummary> {
  late final HealthRepository healthRepository;

  FutureOr<HealthSummary> build({required HealthRepository healthRepository});
}

/// Holds the aggregated [HealthSummary] read from Health Connect.
///
/// Copied from [HealthSummaryNotifier].
@ProviderFor(HealthSummaryNotifier)
const healthSummaryNotifierProvider = HealthSummaryNotifierFamily();

/// Holds the aggregated [HealthSummary] read from Health Connect.
///
/// Copied from [HealthSummaryNotifier].
class HealthSummaryNotifierFamily extends Family<AsyncValue<HealthSummary>> {
  /// Holds the aggregated [HealthSummary] read from Health Connect.
  ///
  /// Copied from [HealthSummaryNotifier].
  const HealthSummaryNotifierFamily();

  /// Holds the aggregated [HealthSummary] read from Health Connect.
  ///
  /// Copied from [HealthSummaryNotifier].
  HealthSummaryNotifierProvider call({
    required HealthRepository healthRepository,
  }) {
    return HealthSummaryNotifierProvider(healthRepository: healthRepository);
  }

  @override
  HealthSummaryNotifierProvider getProviderOverride(
    covariant HealthSummaryNotifierProvider provider,
  ) {
    return call(healthRepository: provider.healthRepository);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'healthSummaryNotifierProvider';
}

/// Holds the aggregated [HealthSummary] read from Health Connect.
///
/// Copied from [HealthSummaryNotifier].
class HealthSummaryNotifierProvider
    extends AsyncNotifierProviderImpl<HealthSummaryNotifier, HealthSummary> {
  /// Holds the aggregated [HealthSummary] read from Health Connect.
  ///
  /// Copied from [HealthSummaryNotifier].
  HealthSummaryNotifierProvider({required HealthRepository healthRepository})
    : this._internal(
        () => HealthSummaryNotifier()..healthRepository = healthRepository,
        from: healthSummaryNotifierProvider,
        name: r'healthSummaryNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$healthSummaryNotifierHash,
        dependencies: HealthSummaryNotifierFamily._dependencies,
        allTransitiveDependencies:
            HealthSummaryNotifierFamily._allTransitiveDependencies,
        healthRepository: healthRepository,
      );

  HealthSummaryNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.healthRepository,
  }) : super.internal();

  final HealthRepository healthRepository;

  @override
  FutureOr<HealthSummary> runNotifierBuild(
    covariant HealthSummaryNotifier notifier,
  ) {
    return notifier.build(healthRepository: healthRepository);
  }

  @override
  Override overrideWith(HealthSummaryNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: HealthSummaryNotifierProvider._internal(
        () => create()..healthRepository = healthRepository,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        healthRepository: healthRepository,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<HealthSummaryNotifier, HealthSummary>
  createElement() {
    return _HealthSummaryNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HealthSummaryNotifierProvider &&
        other.healthRepository == healthRepository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, healthRepository.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HealthSummaryNotifierRef on AsyncNotifierProviderRef<HealthSummary> {
  /// The parameter `healthRepository` of this provider.
  HealthRepository get healthRepository;
}

class _HealthSummaryNotifierProviderElement
    extends AsyncNotifierProviderElement<HealthSummaryNotifier, HealthSummary>
    with HealthSummaryNotifierRef {
  _HealthSummaryNotifierProviderElement(super.provider);

  @override
  HealthRepository get healthRepository =>
      (origin as HealthSummaryNotifierProvider).healthRepository;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
