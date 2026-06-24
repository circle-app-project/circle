// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hla_request_form_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hlaRequestFormNotifierHash() =>
    r'c4992783dcafd6d087aa22e76ccfba81dbec2824';

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

abstract class _$HlaRequestFormNotifier
    extends BuildlessAsyncNotifier<HlaRequestFormState> {
  late final HlaRepository hlaRepository;

  FutureOr<HlaRequestFormState> build({required HlaRepository hlaRepository});
}

/// Holds the in-progress new request the patient is building (subjects + slot
/// + consent) and submits it. The self subject is always present and cannot be
/// removed (AC US-2.1, US-2.4).
///
/// Copied from [HlaRequestFormNotifier].
@ProviderFor(HlaRequestFormNotifier)
const hlaRequestFormNotifierProvider = HlaRequestFormNotifierFamily();

/// Holds the in-progress new request the patient is building (subjects + slot
/// + consent) and submits it. The self subject is always present and cannot be
/// removed (AC US-2.1, US-2.4).
///
/// Copied from [HlaRequestFormNotifier].
class HlaRequestFormNotifierFamily
    extends Family<AsyncValue<HlaRequestFormState>> {
  /// Holds the in-progress new request the patient is building (subjects + slot
  /// + consent) and submits it. The self subject is always present and cannot be
  /// removed (AC US-2.1, US-2.4).
  ///
  /// Copied from [HlaRequestFormNotifier].
  const HlaRequestFormNotifierFamily();

  /// Holds the in-progress new request the patient is building (subjects + slot
  /// + consent) and submits it. The self subject is always present and cannot be
  /// removed (AC US-2.1, US-2.4).
  ///
  /// Copied from [HlaRequestFormNotifier].
  HlaRequestFormNotifierProvider call({required HlaRepository hlaRepository}) {
    return HlaRequestFormNotifierProvider(hlaRepository: hlaRepository);
  }

  @override
  HlaRequestFormNotifierProvider getProviderOverride(
    covariant HlaRequestFormNotifierProvider provider,
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
  String? get name => r'hlaRequestFormNotifierProvider';
}

/// Holds the in-progress new request the patient is building (subjects + slot
/// + consent) and submits it. The self subject is always present and cannot be
/// removed (AC US-2.1, US-2.4).
///
/// Copied from [HlaRequestFormNotifier].
class HlaRequestFormNotifierProvider
    extends
        AsyncNotifierProviderImpl<HlaRequestFormNotifier, HlaRequestFormState> {
  /// Holds the in-progress new request the patient is building (subjects + slot
  /// + consent) and submits it. The self subject is always present and cannot be
  /// removed (AC US-2.1, US-2.4).
  ///
  /// Copied from [HlaRequestFormNotifier].
  HlaRequestFormNotifierProvider({required HlaRepository hlaRepository})
    : this._internal(
        () => HlaRequestFormNotifier()..hlaRepository = hlaRepository,
        from: hlaRequestFormNotifierProvider,
        name: r'hlaRequestFormNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$hlaRequestFormNotifierHash,
        dependencies: HlaRequestFormNotifierFamily._dependencies,
        allTransitiveDependencies:
            HlaRequestFormNotifierFamily._allTransitiveDependencies,
        hlaRepository: hlaRepository,
      );

  HlaRequestFormNotifierProvider._internal(
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
  FutureOr<HlaRequestFormState> runNotifierBuild(
    covariant HlaRequestFormNotifier notifier,
  ) {
    return notifier.build(hlaRepository: hlaRepository);
  }

  @override
  Override overrideWith(HlaRequestFormNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: HlaRequestFormNotifierProvider._internal(
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
  AsyncNotifierProviderElement<HlaRequestFormNotifier, HlaRequestFormState>
  createElement() {
    return _HlaRequestFormNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HlaRequestFormNotifierProvider &&
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
mixin HlaRequestFormNotifierRef
    on AsyncNotifierProviderRef<HlaRequestFormState> {
  /// The parameter `hlaRepository` of this provider.
  HlaRepository get hlaRepository;
}

class _HlaRequestFormNotifierProviderElement
    extends
        AsyncNotifierProviderElement<
          HlaRequestFormNotifier,
          HlaRequestFormState
        >
    with HlaRequestFormNotifierRef {
  _HlaRequestFormNotifierProviderElement(super.provider);

  @override
  HlaRepository get hlaRepository =>
      (origin as HlaRequestFormNotifierProvider).hlaRepository;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
