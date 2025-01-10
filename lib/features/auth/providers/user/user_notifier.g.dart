// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userNotifierHash() => r'7d125b4231afe6ca09310a819cd4ac700d079a8b';

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

abstract class _$UserNotifier extends BuildlessAsyncNotifier<AppUser> {
  late final UserRepository userRepository;

  FutureOr<AppUser> build({
    required UserRepository userRepository,
  });
}

/// See also [UserNotifier].
@ProviderFor(UserNotifier)
const userNotifierProvider = UserNotifierFamily();

/// See also [UserNotifier].
class UserNotifierFamily extends Family<AsyncValue<AppUser>> {
  /// See also [UserNotifier].
  const UserNotifierFamily();

  /// See also [UserNotifier].
  UserNotifierProvider call({
    required UserRepository userRepository,
  }) {
    return UserNotifierProvider(
      userRepository: userRepository,
    );
  }

  @override
  UserNotifierProvider getProviderOverride(
    covariant UserNotifierProvider provider,
  ) {
    return call(
      userRepository: provider.userRepository,
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
  String? get name => r'userNotifierProvider';
}

/// See also [UserNotifier].
class UserNotifierProvider
    extends AsyncNotifierProviderImpl<UserNotifier, AppUser> {
  /// See also [UserNotifier].
  UserNotifierProvider({
    required UserRepository userRepository,
  }) : this._internal(
          () => UserNotifier()..userRepository = userRepository,
          from: userNotifierProvider,
          name: r'userNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userNotifierHash,
          dependencies: UserNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserNotifierFamily._allTransitiveDependencies,
          userRepository: userRepository,
        );

  UserNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userRepository,
  }) : super.internal();

  final UserRepository userRepository;

  @override
  FutureOr<AppUser> runNotifierBuild(
    covariant UserNotifier notifier,
  ) {
    return notifier.build(
      userRepository: userRepository,
    );
  }

  @override
  Override overrideWith(UserNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserNotifierProvider._internal(
        () => create()..userRepository = userRepository,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userRepository: userRepository,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<UserNotifier, AppUser> createElement() {
    return _UserNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserNotifierProvider &&
        other.userRepository == userRepository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userRepository.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserNotifierRef on AsyncNotifierProviderRef<AppUser> {
  /// The parameter `userRepository` of this provider.
  UserRepository get userRepository;
}

class _UserNotifierProviderElement
    extends AsyncNotifierProviderElement<UserNotifier, AppUser>
    with UserNotifierRef {
  _UserNotifierProviderElement(super.provider);

  @override
  UserRepository get userRepository =>
      (origin as UserNotifierProvider).userRepository;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
