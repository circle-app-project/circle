// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_log_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waterLogNotifierHash() => r'447fd43dec5085ee9d38a4c161c54e7fa1c03486';

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

abstract class _$WaterLogNotifier
    extends BuildlessAsyncNotifier<List<WaterLog>> {
  late final WaterRepository waterRepository;

  FutureOr<List<WaterLog>> build({
    required WaterRepository waterRepository,
  });
}

/// See also [WaterLogNotifier].
@ProviderFor(WaterLogNotifier)
const waterLogNotifierProvider = WaterLogNotifierFamily();

/// See also [WaterLogNotifier].
class WaterLogNotifierFamily extends Family<AsyncValue<List<WaterLog>>> {
  /// See also [WaterLogNotifier].
  const WaterLogNotifierFamily();

  /// See also [WaterLogNotifier].
  WaterLogNotifierProvider call({
    required WaterRepository waterRepository,
  }) {
    return WaterLogNotifierProvider(
      waterRepository: waterRepository,
    );
  }

  @override
  WaterLogNotifierProvider getProviderOverride(
    covariant WaterLogNotifierProvider provider,
  ) {
    return call(
      waterRepository: provider.waterRepository,
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
  String? get name => r'waterLogNotifierProvider';
}

/// See also [WaterLogNotifier].
class WaterLogNotifierProvider
    extends AsyncNotifierProviderImpl<WaterLogNotifier, List<WaterLog>> {
  /// See also [WaterLogNotifier].
  WaterLogNotifierProvider({
    required WaterRepository waterRepository,
  }) : this._internal(
          () => WaterLogNotifier()..waterRepository = waterRepository,
          from: waterLogNotifierProvider,
          name: r'waterLogNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$waterLogNotifierHash,
          dependencies: WaterLogNotifierFamily._dependencies,
          allTransitiveDependencies:
              WaterLogNotifierFamily._allTransitiveDependencies,
          waterRepository: waterRepository,
        );

  WaterLogNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.waterRepository,
  }) : super.internal();

  final WaterRepository waterRepository;

  @override
  FutureOr<List<WaterLog>> runNotifierBuild(
    covariant WaterLogNotifier notifier,
  ) {
    return notifier.build(
      waterRepository: waterRepository,
    );
  }

  @override
  Override overrideWith(WaterLogNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WaterLogNotifierProvider._internal(
        () => create()..waterRepository = waterRepository,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        waterRepository: waterRepository,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<WaterLogNotifier, List<WaterLog>>
      createElement() {
    return _WaterLogNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WaterLogNotifierProvider &&
        other.waterRepository == waterRepository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, waterRepository.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WaterLogNotifierRef on AsyncNotifierProviderRef<List<WaterLog>> {
  /// The parameter `waterRepository` of this provider.
  WaterRepository get waterRepository;
}

class _WaterLogNotifierProviderElement
    extends AsyncNotifierProviderElement<WaterLogNotifier, List<WaterLog>>
    with WaterLogNotifierRef {
  _WaterLogNotifierProviderElement(super.provider);

  @override
  WaterRepository get waterRepository =>
      (origin as WaterLogNotifierProvider).waterRepository;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
