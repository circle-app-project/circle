import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../core/utils/enums.dart';
import '../../auth.dart';

@Entity()
// ignore: must_be_immutable
class AppUser
    extends Equatable {
  @Id()
  int id;
  @Unique(onConflict: ConflictStrategy.replace)
  final String uid;
  final String email;
  final String? photoUrl;
  final bool isAnonymous;
  final bool isEmailVerified;
  final bool? isPhoneVerified;
  final ToOne<UserProfile> profile = ToOne<UserProfile>();

  @Transient()
  UserPreferences? preferences;

  String get dbPreferences => jsonEncode(preferences?.toMap());

  set dbPreferences(String? jsonString) {
    if (jsonString != null) {
      final Map<String, dynamic> preferencesMap = jsonDecode(jsonString);
      preferences = UserPreferences.fromMap(data: preferencesMap);
    } else {
      preferences = null;
    }
  }

  AppUser({
    this.id = 0,
    required this.email,
    required this.isAnonymous,
    required this.uid,
    required this.isEmailVerified,
    this.isPhoneVerified,
    this.photoUrl,
    this.preferences,
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
    AppUser user = AppUser(
      id: id,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      preferences: preferences ?? this.preferences,
    );
    user.profile.target = profile ?? this.profile.target;
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
      "preferences":
          preferences != null
              ? preferences?.toMap()
              : UnitPreferences.metric().toMap(),
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
      preferences:
          data["preferences"] != null
              ? UserPreferences.fromMap(data: data["preferences"])
              : null,
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
      );
    }
  }

  //-------Empty--------//
  @Transient()
  static AppUser empty = AppUser(
    email: "",
    uid: "",
    isAnonymous: false,
    isEmailVerified: false,
    isPhoneVerified: false,
    preferences: null,
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
    // Attempt to retrieve the UserProfile object
    UserProfile? uProfile = profile.target;

    // Check if UserProfile exists
    if (uProfile != null) {
      // Try to get the display name, fallback to the first part of the real name if display name is null
      if (uProfile.displayName?.isNotEmpty ?? false) {
        return uProfile.displayName!.split(" ").first;
      } else if (uProfile.name?.isNotEmpty ?? false) {
        return uProfile.name!.split(" ").first;
      }
    }

    // Final fallback to email
    return email;
  }

  //-------Sample User--------//
  @Transient()
  static AppUser get sample {
    AppUser sampleUser = AppUser(
      email: "user1@email.com",
      uid: "dws7efwjcpsoah983jcskbac",
      photoUrl:
      "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      isAnonymous: false,
      isEmailVerified: true,
      isPhoneVerified: true,
      preferences: UserPreferences(
        isFirstTime: false,
        isOnboarded: true,
        unitPreferences: UnitPreferences.metric(),
      ),
    );

   sampleUser = sampleUser.copyWith(
      profile: UserProfile(
        age: 23,
        id: 1,
        name: "John Doe",
        email: "user1@email.com",
        uid: "dws7efwjcpsoah983jcskbac",
        weight: 68,
        height: 178,
        bloodGroup: "O+",
        gender: Gender.male,
        genotype: Genotype.ss,
        allergies: ["Penicillin", "Aspirin"],
        medicalConditions: ["Diabetes", "Heart Disease"],
        painSeverity: 8,
        crisisFrequency: "Daily",
        displayName: "Johny",
        photoUrl:
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        phone: "+237123456789",
        bmi: 18.2,
      ),
    );
    return sampleUser;
  }
}
