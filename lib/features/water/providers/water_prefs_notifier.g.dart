// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_prefs_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waterPrefsNotifierHash() =>
    r'a22212f3c96bbe01fe6cf58d59b55698df6db836';

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

abstract class _$WaterPrefsNotifier
    extends BuildlessAsyncNotifier<WaterPreferences> {
  late final WaterRepository waterRepository;

  FutureOr<WaterPreferences> build({
    required WaterRepository waterRepository,
  });
}

/// See also [WaterPrefsNotifier].
@ProviderFor(WaterPrefsNotifier)
const waterPrefsNotifierProvider = WaterPrefsNotifierFamily();

/// See also [WaterPrefsNotifier].
class WaterPrefsNotifierFamily extends Family<AsyncValue<WaterPreferences>> {
  /// See also [WaterPrefsNotifier].
  const WaterPrefsNotifierFamily();

  /// See also [WaterPrefsNotifier].
  WaterPrefsNotifierProvider call({
    required WaterRepository waterRepository,
  }) {
    return WaterPrefsNotifierProvider(
      waterRepository: waterRepository,
    );
  }

  @override
  WaterPrefsNotifierProvider getProviderOverride(
    covariant WaterPrefsNotifierProvider provider,
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
  String? get name => r'waterPrefsNotifierProvider';
}

/// See also [WaterPrefsNotifier].
class WaterPrefsNotifierProvider
    extends AsyncNotifierProviderImpl<WaterPrefsNotifier, WaterPreferences> {
  /// See also [WaterPrefsNotifier].
  WaterPrefsNotifierProvider({
    required WaterRepository waterRepository,
  }) : this._internal(
          () => WaterPrefsNotifier()..waterRepository = waterRepository,
          from: waterPrefsNotifierProvider,
          name: r'waterPrefsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$waterPrefsNotifierHash,
          dependencies: WaterPrefsNotifierFamily._dependencies,
          allTransitiveDependencies:
              WaterPrefsNotifierFamily._allTransitiveDependencies,
          waterRepository: waterRepository,
        );

  WaterPrefsNotifierProvider._internal(
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
  FutureOr<WaterPreferences> runNotifierBuild(
    covariant WaterPrefsNotifier notifier,
  ) {
    return notifier.build(
      waterRepository: waterRepository,
    );
  }

  @override
  Override overrideWith(WaterPrefsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WaterPrefsNotifierProvider._internal(
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
  AsyncNotifierProviderElement<WaterPrefsNotifier, WaterPreferences>
      createElement() {
    return _WaterPrefsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WaterPrefsNotifierProvider &&
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
mixin WaterPrefsNotifierRef on AsyncNotifierProviderRef<WaterPreferences> {
  /// The parameter `waterRepository` of this provider.
  WaterRepository get waterRepository;
}

class _WaterPrefsNotifierProviderElement
    extends AsyncNotifierProviderElement<WaterPrefsNotifier, WaterPreferences>
    with WaterPrefsNotifierRef {
  _WaterPrefsNotifierProviderElement(super.provider);

  @override
  WaterRepository get waterRepository =>
      (origin as WaterPrefsNotifierProvider).waterRepository;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
