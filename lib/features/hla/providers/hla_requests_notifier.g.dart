// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hla_requests_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hlaRequestsNotifierHash() =>
    r'b4b70f4a2f939e2eb41e8196e00ba98dd9dd699e';

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

abstract class _$HlaRequestsNotifier
    extends BuildlessAsyncNotifier<List<HlaTestRequest>> {
  late final HlaRepository hlaRepository;

  FutureOr<List<HlaTestRequest>> build({required HlaRepository hlaRepository});
}

/// Patient-facing list of the signed-in user's HLA requests.
///
/// Copied from [HlaRequestsNotifier].
@ProviderFor(HlaRequestsNotifier)
const hlaRequestsNotifierProvider = HlaRequestsNotifierFamily();

/// Patient-facing list of the signed-in user's HLA requests.
///
/// Copied from [HlaRequestsNotifier].
class HlaRequestsNotifierFamily
    extends Family<AsyncValue<List<HlaTestRequest>>> {
  /// Patient-facing list of the signed-in user's HLA requests.
  ///
  /// Copied from [HlaRequestsNotifier].
  const HlaRequestsNotifierFamily();

  /// Patient-facing list of the signed-in user's HLA requests.
  ///
  /// Copied from [HlaRequestsNotifier].
  HlaRequestsNotifierProvider call({required HlaRepository hlaRepository}) {
    return HlaRequestsNotifierProvider(hlaRepository: hlaRepository);
  }

  @override
  HlaRequestsNotifierProvider getProviderOverride(
    covariant HlaRequestsNotifierProvider provider,
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
  String? get name => r'hlaRequestsNotifierProvider';
}

/// Patient-facing list of the signed-in user's HLA requests.
///
/// Copied from [HlaRequestsNotifier].
class HlaRequestsNotifierProvider
    extends
        AsyncNotifierProviderImpl<HlaRequestsNotifier, List<HlaTestRequest>> {
  /// Patient-facing list of the signed-in user's HLA requests.
  ///
  /// Copied from [HlaRequestsNotifier].
  HlaRequestsNotifierProvider({required HlaRepository hlaRepository})
    : this._internal(
        () => HlaRequestsNotifier()..hlaRepository = hlaRepository,
        from: hlaRequestsNotifierProvider,
        name: r'hlaRequestsNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$hlaRequestsNotifierHash,
        dependencies: HlaRequestsNotifierFamily._dependencies,
        allTransitiveDependencies:
            HlaRequestsNotifierFamily._allTransitiveDependencies,
        hlaRepository: hlaRepository,
      );

  HlaRequestsNotifierProvider._internal(
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
    covariant HlaRequestsNotifier notifier,
  ) {
    return notifier.build(hlaRepository: hlaRepository);
  }

  @override
  Override overrideWith(HlaRequestsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: HlaRequestsNotifierProvider._internal(
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
  AsyncNotifierProviderElement<HlaRequestsNotifier, List<HlaTestRequest>>
  createElement() {
    return _HlaRequestsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HlaRequestsNotifierProvider &&
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
mixin HlaRequestsNotifierRef on AsyncNotifierProviderRef<List<HlaTestRequest>> {
  /// The parameter `hlaRepository` of this provider.
  HlaRepository get hlaRepository;
}

class _HlaRequestsNotifierProviderElement
    extends
        AsyncNotifierProviderElement<HlaRequestsNotifier, List<HlaTestRequest>>
    with HlaRequestsNotifierRef {
  _HlaRequestsNotifierProviderElement(super.provider);

  @override
  HlaRepository get hlaRepository =>
      (origin as HlaRequestsNotifierProvider).hlaRepository;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
