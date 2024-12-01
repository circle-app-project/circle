import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:objectbox/objectbox.dart';

import '../../auth.dart';

@Entity()
// ignore: must_be_immutable
class AppUser extends Equatable {
  @Id()
  int id;
  final String uid;
  final String email;
  final String? photoUrl;
  final bool isAnonymous;
  final bool isEmailVerified;
  final bool? isPhoneVerified;
  final ToOne<UserProfile> profile = ToOne<UserProfile>();
  final ToOne<UserPreferences> preferences = ToOne<UserPreferences>();

  AppUser({
    this.id = 0,
    required this.email,
    required this.isAnonymous,
    required this.uid,
    required this.isEmailVerified,
    this.isPhoneVerified,
    this.photoUrl,
  });

  //-------copyWith--------//
  AppUser copyWith({
    String? email,
    bool? isAnonymous,
    String? uid,
    String? photoUrl,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    UserProfile? profile,
    UserPreferences? preferences,
  }) {
    final AppUser user = AppUser(
      id: id,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
    user.profile.target = profile ?? this.profile.target;
    user.preferences.target = preferences ?? this.preferences.target;
    return user;
  }

  //-----To Map and From Map------//
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "uid": uid,
      "email": email,
      "photoUrl": photoUrl,
      "isAnonymous": isAnonymous,
      "isEmailVerified": isEmailVerified,
      "isPhoneVerified": isPhoneVerified,
      "profile": profile.target!.toMap(),
      "preferences": preferences.target!.toMap(),
    };

    return data;
  }

  factory AppUser.fromMap({required Map<String, dynamic> data}) {
    return AppUser(
      //  profile: UserProfile.fromMap(data["profile"]),
      //  preferences: UserPreferences.fromMap(data: data["preferences"]),
      email: data["email"],
      uid: data["uid"],
      isAnonymous: data["isAnonymous"],
      isEmailVerified: data["isEmailVerified"],
      isPhoneVerified: data["isPhoneVerified"],
    );
  }

  factory AppUser.fromUser({required User? user}) {
    if (user == null) {
      return AppUser.empty;
    } else {
      return AppUser(
        email: user.email!,
        uid: user.uid,
        isEmailVerified: user.emailVerified,
        isAnonymous: user.isAnonymous,
        photoUrl: user.photoURL,
        isPhoneVerified: false,
      );
    }
  }

  //-------Empty--------//
  @Transient()
  static AppUser empty = AppUser(
    email: "",
    isAnonymous: false,
    uid: "",
    isEmailVerified: false,
    isPhoneVerified: false,
  );

  @Transient()
  bool get isEmpty => this == AppUser.empty;
  @Transient()
  bool get isNotEmpty => this != AppUser.empty;

  @override
  String toString() {
    if (this == AppUser.empty) {
      return "AppUser.empty";
    }

    return super.toString();
  }

  @override
  @Transient()
  bool? get stringify => true;

  @override
  @Transient()
  List<Object?> get props => [
    id,
    email,
    photoUrl,
    isAnonymous,
    isEmailVerified,
    uid,
    isPhoneVerified,
    profile,
    preferences,
  ];

  String getDisplayName() {
    UserProfile? uProfile = profile.target;

    if (uProfile != null) {
      if (uProfile.displayName != null) {
        return uProfile.displayName!.split(" ").first;
      } else {
        if (uProfile.name != null) {
          return uProfile.name!.split(" ").first;
        }
      }
    }

    return email;
  }
}
