// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'ea888448fd9439a7fa18aaee6c9ff5d299f0ae20';

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

abstract class _$AuthNotifier extends BuildlessAsyncNotifier<AppUser> {
  late final AuthRepository authRepository;

  FutureOr<AppUser> build({
    required AuthRepository authRepository,
  });
}

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
const authNotifierProvider = AuthNotifierFamily();

/// See also [AuthNotifier].
class AuthNotifierFamily extends Family<AsyncValue<AppUser>> {
  /// See also [AuthNotifier].
  const AuthNotifierFamily();

  /// See also [AuthNotifier].
  AuthNotifierProvider call({
    required AuthRepository authRepository,
  }) {
    return AuthNotifierProvider(
      authRepository: authRepository,
    );
  }

  @override
  AuthNotifierProvider getProviderOverride(
    covariant AuthNotifierProvider provider,
  ) {
    return call(
      authRepository: provider.authRepository,
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
  String? get name => r'authNotifierProvider';
}

/// See also [AuthNotifier].
class AuthNotifierProvider
    extends AsyncNotifierProviderImpl<AuthNotifier, AppUser> {
  /// See also [AuthNotifier].
  AuthNotifierProvider({
    required AuthRepository authRepository,
  }) : this._internal(
          () => AuthNotifier()..authRepository = authRepository,
          from: authNotifierProvider,
          name: r'authNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$authNotifierHash,
          dependencies: AuthNotifierFamily._dependencies,
          allTransitiveDependencies:
              AuthNotifierFamily._allTransitiveDependencies,
          authRepository: authRepository,
        );

  AuthNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.authRepository,
  }) : super.internal();

  final AuthRepository authRepository;

  @override
  FutureOr<AppUser> runNotifierBuild(
    covariant AuthNotifier notifier,
  ) {
    return notifier.build(
      authRepository: authRepository,
    );
  }

  @override
  Override overrideWith(AuthNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AuthNotifierProvider._internal(
        () => create()..authRepository = authRepository,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        authRepository: authRepository,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<AuthNotifier, AppUser> createElement() {
    return _AuthNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuthNotifierProvider &&
        other.authRepository == authRepository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, authRepository.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AuthNotifierRef on AsyncNotifierProviderRef<AppUser> {
  /// The parameter `authRepository` of this provider.
  AuthRepository get authRepository;
}

class _AuthNotifierProviderElement
    extends AsyncNotifierProviderElement<AuthNotifier, AppUser>
    with AuthNotifierRef {
  _AuthNotifierProviderElement(super.provider);

  @override
  AuthRepository get authRepository =>
      (origin as AuthNotifierProvider).authRepository;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
