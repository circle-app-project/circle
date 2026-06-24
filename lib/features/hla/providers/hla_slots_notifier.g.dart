// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hla_slots_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hlaSlotsNotifierHash() => r'1b1c107238507d6127efdfdd9331da985178dc88';

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

abstract class _$HlaSlotsNotifier
    extends BuildlessAsyncNotifier<List<HlaAppointmentSlot>> {
  late final HlaRepository hlaRepository;

  FutureOr<List<HlaAppointmentSlot>> build({
    required HlaRepository hlaRepository,
  });
}

/// Loads the bookable appointment slots a patient can choose from (future,
/// active, not full).
///
/// Copied from [HlaSlotsNotifier].
@ProviderFor(HlaSlotsNotifier)
const hlaSlotsNotifierProvider = HlaSlotsNotifierFamily();

/// Loads the bookable appointment slots a patient can choose from (future,
/// active, not full).
///
/// Copied from [HlaSlotsNotifier].
class HlaSlotsNotifierFamily
    extends Family<AsyncValue<List<HlaAppointmentSlot>>> {
  /// Loads the bookable appointment slots a patient can choose from (future,
  /// active, not full).
  ///
  /// Copied from [HlaSlotsNotifier].
  const HlaSlotsNotifierFamily();

  /// Loads the bookable appointment slots a patient can choose from (future,
  /// active, not full).
  ///
  /// Copied from [HlaSlotsNotifier].
  HlaSlotsNotifierProvider call({required HlaRepository hlaRepository}) {
    return HlaSlotsNotifierProvider(hlaRepository: hlaRepository);
  }

  @override
  HlaSlotsNotifierProvider getProviderOverride(
    covariant HlaSlotsNotifierProvider provider,
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
  String? get name => r'hlaSlotsNotifierProvider';
}

/// Loads the bookable appointment slots a patient can choose from (future,
/// active, not full).
///
/// Copied from [HlaSlotsNotifier].
class HlaSlotsNotifierProvider
    extends
        AsyncNotifierProviderImpl<HlaSlotsNotifier, List<HlaAppointmentSlot>> {
  /// Loads the bookable appointment slots a patient can choose from (future,
  /// active, not full).
  ///
  /// Copied from [HlaSlotsNotifier].
  HlaSlotsNotifierProvider({required HlaRepository hlaRepository})
    : this._internal(
        () => HlaSlotsNotifier()..hlaRepository = hlaRepository,
        from: hlaSlotsNotifierProvider,
        name: r'hlaSlotsNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$hlaSlotsNotifierHash,
        dependencies: HlaSlotsNotifierFamily._dependencies,
        allTransitiveDependencies:
            HlaSlotsNotifierFamily._allTransitiveDependencies,
        hlaRepository: hlaRepository,
      );

  HlaSlotsNotifierProvider._internal(
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
    covariant HlaSlotsNotifier notifier,
  ) {
    return notifier.build(hlaRepository: hlaRepository);
  }

  @override
  Override overrideWith(HlaSlotsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: HlaSlotsNotifierProvider._internal(
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
  AsyncNotifierProviderElement<HlaSlotsNotifier, List<HlaAppointmentSlot>>
  createElement() {
    return _HlaSlotsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HlaSlotsNotifierProvider &&
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
mixin HlaSlotsNotifierRef
    on AsyncNotifierProviderRef<List<HlaAppointmentSlot>> {
  /// The parameter `hlaRepository` of this provider.
  HlaRepository get hlaRepository;
}

class _HlaSlotsNotifierProviderElement
    extends
        AsyncNotifierProviderElement<HlaSlotsNotifier, List<HlaAppointmentSlot>>
    with HlaSlotsNotifierRef {
  _HlaSlotsNotifierProviderElement(super.provider);

  @override
  HlaRepository get hlaRepository =>
      (origin as HlaSlotsNotifierProvider).hlaRepository;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
