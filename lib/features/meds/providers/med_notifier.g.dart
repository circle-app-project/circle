// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$medNotifierHash() => r'6f64293afc750bb7f9410e6245fa68bbe42fccdf';

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

abstract class _$MedNotifier extends BuildlessAsyncNotifier<List<Medication>> {
  late final MedRepository medRepository;

  FutureOr<List<Medication>> build({
    required MedRepository medRepository,
  });
}

/// See also [MedNotifier].
@ProviderFor(MedNotifier)
const medNotifierProvider = MedNotifierFamily();

/// See also [MedNotifier].
class MedNotifierFamily extends Family<AsyncValue<List<Medication>>> {
  /// See also [MedNotifier].
  const MedNotifierFamily();

  /// See also [MedNotifier].
  MedNotifierProvider call({
    required MedRepository medRepository,
  }) {
    return MedNotifierProvider(
      medRepository: medRepository,
    );
  }

  @override
  MedNotifierProvider getProviderOverride(
    covariant MedNotifierProvider provider,
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
  String? get name => r'medNotifierProvider';
}

/// See also [MedNotifier].
class MedNotifierProvider
    extends AsyncNotifierProviderImpl<MedNotifier, List<Medication>> {
  /// See also [MedNotifier].
  MedNotifierProvider({
    required MedRepository medRepository,
  }) : this._internal(
          () => MedNotifier()..medRepository = medRepository,
          from: medNotifierProvider,
          name: r'medNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$medNotifierHash,
          dependencies: MedNotifierFamily._dependencies,
          allTransitiveDependencies:
              MedNotifierFamily._allTransitiveDependencies,
          medRepository: medRepository,
        );

  MedNotifierProvider._internal(
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
  FutureOr<List<Medication>> runNotifierBuild(
    covariant MedNotifier notifier,
  ) {
    return notifier.build(
      medRepository: medRepository,
    );
  }

  @override
  Override overrideWith(MedNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MedNotifierProvider._internal(
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
  AsyncNotifierProviderElement<MedNotifier, List<Medication>> createElement() {
    return _MedNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MedNotifierProvider && other.medRepository == medRepository;
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
mixin MedNotifierRef on AsyncNotifierProviderRef<List<Medication>> {
  /// The parameter `medRepository` of this provider.
  MedRepository get medRepository;
}

class _MedNotifierProviderElement
    extends AsyncNotifierProviderElement<MedNotifier, List<Medication>>
    with MedNotifierRef {
  _MedNotifierProviderElement(super.provider);

  @override
  MedRepository get medRepository =>
      (origin as MedNotifierProvider).medRepository;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
