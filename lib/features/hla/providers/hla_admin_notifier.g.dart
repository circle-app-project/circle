// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hla_admin_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hlaAdminNotifierHash() => r'a07b5731f4ead5b0fb1ba1c3dffec889871e4e74';

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

abstract class _$HlaAdminNotifier
    extends BuildlessAsyncNotifier<List<HlaTestRequest>> {
  late final HlaRepository hlaRepository;

  FutureOr<List<HlaTestRequest>> build({required HlaRepository hlaRepository});
}

/// Admin: the full request queue, with actions to advance status and upload
/// results. Visible only to `role == admin` users (UI gate + Firestore rules).
///
/// Copied from [HlaAdminNotifier].
@ProviderFor(HlaAdminNotifier)
const hlaAdminNotifierProvider = HlaAdminNotifierFamily();

/// Admin: the full request queue, with actions to advance status and upload
/// results. Visible only to `role == admin` users (UI gate + Firestore rules).
///
/// Copied from [HlaAdminNotifier].
class HlaAdminNotifierFamily extends Family<AsyncValue<List<HlaTestRequest>>> {
  /// Admin: the full request queue, with actions to advance status and upload
  /// results. Visible only to `role == admin` users (UI gate + Firestore rules).
  ///
  /// Copied from [HlaAdminNotifier].
  const HlaAdminNotifierFamily();

  /// Admin: the full request queue, with actions to advance status and upload
  /// results. Visible only to `role == admin` users (UI gate + Firestore rules).
  ///
  /// Copied from [HlaAdminNotifier].
  HlaAdminNotifierProvider call({required HlaRepository hlaRepository}) {
    return HlaAdminNotifierProvider(hlaRepository: hlaRepository);
  }

  @override
  HlaAdminNotifierProvider getProviderOverride(
    covariant HlaAdminNotifierProvider provider,
  ) {
    return call(hlaRepository: provider.hlaRepository);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hlaAdminNotifierProvider';
}

/// Admin: the full request queue, with actions to advance status and upload
/// results. Visible only to `role == admin` users (UI gate + Firestore rules).
///
/// Copied from [HlaAdminNotifier].
class HlaAdminNotifierProvider
    extends AsyncNotifierProviderImpl<HlaAdminNotifier, List<HlaTestRequest>> {
  /// Admin: the full request queue, with actions to advance status and upload
  /// results. Visible only to `role == admin` users (UI gate + Firestore rules).
  ///
  /// Copied from [HlaAdminNotifier].
  HlaAdminNotifierProvider({required HlaRepository hlaRepository})
    : this._internal(
        () => HlaAdminNotifier()..hlaRepository = hlaRepository,
        from: hlaAdminNotifierProvider,
        name: r'hlaAdminNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$hlaAdminNotifierHash,
        dependencies: HlaAdminNotifierFamily._dependencies,
        allTransitiveDependencies:
            HlaAdminNotifierFamily._allTransitiveDependencies,
        hlaRepository: hlaRepository,
      );

  HlaAdminNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.hlaRepository,
  }) : super.internal();

  final HlaRepository hlaRepository;

  @override
  FutureOr<List<HlaTestRequest>> runNotifierBuild(
    covariant HlaAdminNotifier notifier,
  ) {
    return notifier.build(hlaRepository: hlaRepository);
  }

  @override
  Override overrideWith(HlaAdminNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: HlaAdminNotifierProvider._internal(
        () => create()..hlaRepository = hlaRepository,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        hlaRepository: hlaRepository,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<HlaAdminNotifier, List<HlaTestRequest>>
  createElement() {
    return _HlaAdminNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HlaAdminNotifierProvider &&
        other.hlaRepository == hlaRepository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, hlaRepository.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HlaAdminNotifierRef on AsyncNotifierProviderRef<List<HlaTestRequest>> {
  /// The parameter `hlaRepository` of this provider.
  HlaRepository get hlaRepository;
}

class _HlaAdminNotifierProviderElement
    extends AsyncNotifierProviderElement<HlaAdminNotifier, List<HlaTestRequest>>
    with HlaAdminNotifierRef {
  _HlaAdminNotifierProviderElement(super.provider);

  @override
  HlaRepository get hlaRepository =>
      (origin as HlaAdminNotifierProvider).hlaRepository;
}

String _$hlaAdminSlotsNotifierHash() =>
    r'ec8a6a5d277acd6fe1e38fe2bb1c13f9b5e8e1fc';

abstract class _$HlaAdminSlotsNotifier
    extends BuildlessAsyncNotifier<List<HlaAppointmentSlot>> {
  late final HlaRepository hlaRepository;

  FutureOr<List<HlaAppointmentSlot>> build({
    required HlaRepository hlaRepository,
  });
}

/// Admin: appointment slot management (create/update/deactivate).
///
/// Copied from [HlaAdminSlotsNotifier].
@ProviderFor(HlaAdminSlotsNotifier)
const hlaAdminSlotsNotifierProvider = HlaAdminSlotsNotifierFamily();

/// Admin: appointment slot management (create/update/deactivate).
///
/// Copied from [HlaAdminSlotsNotifier].
class HlaAdminSlotsNotifierFamily
    extends Family<AsyncValue<List<HlaAppointmentSlot>>> {
  /// Admin: appointment slot management (create/update/deactivate).
  ///
  /// Copied from [HlaAdminSlotsNotifier].
  const HlaAdminSlotsNotifierFamily();

  /// Admin: appointment slot management (create/update/deactivate).
  ///
  /// Copied from [HlaAdminSlotsNotifier].
  HlaAdminSlotsNotifierProvider call({required HlaRepository hlaRepository}) {
    return HlaAdminSlotsNotifierProvider(hlaRepository: hlaRepository);
  }

  @override
  HlaAdminSlotsNotifierProvider getProviderOverride(
    covariant HlaAdminSlotsNotifierProvider provider,
  ) {
    return call(hlaRepository: provider.hlaRepository);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hlaAdminSlotsNotifierProvider';
}

/// Admin: appointment slot management (create/update/deactivate).
///
/// Copied from [HlaAdminSlotsNotifier].
class HlaAdminSlotsNotifierProvider
    extends
        AsyncNotifierProviderImpl<
          HlaAdminSlotsNotifier,
          List<HlaAppointmentSlot>
        > {
  /// Admin: appointment slot management (create/update/deactivate).
  ///
  /// Copied from [HlaAdminSlotsNotifier].
  HlaAdminSlotsNotifierProvider({required HlaRepository hlaRepository})
    : this._internal(
        () => HlaAdminSlotsNotifier()..hlaRepository = hlaRepository,
        from: hlaAdminSlotsNotifierProvider,
        name: r'hlaAdminSlotsNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$hlaAdminSlotsNotifierHash,
        dependencies: HlaAdminSlotsNotifierFamily._dependencies,
        allTransitiveDependencies:
            HlaAdminSlotsNotifierFamily._allTransitiveDependencies,
        hlaRepository: hlaRepository,
      );

  HlaAdminSlotsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.hlaRepository,
  }) : super.internal();

  final HlaRepository hlaRepository;

  @override
  FutureOr<List<HlaAppointmentSlot>> runNotifierBuild(
    covariant HlaAdminSlotsNotifier notifier,
  ) {
    return notifier.build(hlaRepository: hlaRepository);
  }

  @override
  Override overrideWith(HlaAdminSlotsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: HlaAdminSlotsNotifierProvider._internal(
        () => create()..hlaRepository = hlaRepository,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        hlaRepository: hlaRepository,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<HlaAdminSlotsNotifier, List<HlaAppointmentSlot>>
  createElement() {
    return _HlaAdminSlotsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HlaAdminSlotsNotifierProvider &&
        other.hlaRepository == hlaRepository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, hlaRepository.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HlaAdminSlotsNotifierRef
    on AsyncNotifierProviderRef<List<HlaAppointmentSlot>> {
  /// The parameter `hlaRepository` of this provider.
  HlaRepository get hlaRepository;
}

class _HlaAdminSlotsNotifierProviderElement
    extends
        AsyncNotifierProviderElement<
          HlaAdminSlotsNotifier,
          List<HlaAppointmentSlot>
        >
    with HlaAdminSlotsNotifierRef {
  _HlaAdminSlotsNotifierProviderElement(super.provider);

  @override
  HlaRepository get hlaRepository =>
      (origin as HlaAdminSlotsNotifierProvider).hlaRepository;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
