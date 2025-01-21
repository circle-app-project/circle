import 'dart:convert';

import 'package:circle/features/auth/models/user/user_preferences.dart';
import 'package:circle/features/auth/models/user/user_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../core/utils/enums.dart';

/// Represents an application user with various attributes and preferences.
///
/// The `AppUser` class integrates with ObjectBox for local storage,
/// Firebase Authentication for user management, and supports JSON
/// serialization for remote storage or transfer.
@Entity()
// ignore: must_be_immutable
class AppUser extends Equatable {
  /// Unique identifier for ObjectBox.
  @Id()
  int id;

  /// Unique identifier for the user (Firebase UID).
  @Unique(onConflict: ConflictStrategy.replace)
  final String uid;

  /// Email address of the user.
  final String email;

  /// URL of the user's profile picture.
  final String? photoUrl;

  /// Indicates if the user is anonymous.
  final bool isAnonymous;

  /// Indicates if the user's email is verified.
  final bool isEmailVerified;

  /// Indicates if the user's phone number is verified.
  final bool? isPhoneVerified;

  /// A reference to the user's profile stored as a `ToOne` relation in ObjectBox.
  final ToOne<UserProfile> profile = ToOne<UserProfile>();

  /// User preferences, stored as a transient field (not persisted in ObjectBox).
  @Transient()
  UserPreferences? preferences;


  /// ----- OBJECTBOX TYPE CONVERTERS ----- ///
  ///
  /// Encodes user preferences into a JSON string for storage.
  String get dbPreferences => jsonEncode(preferences?.toMap());

  /// Decodes a JSON string into user preferences.
  set dbPreferences(String? jsonString) {
    if (jsonString != null) {
      final Map<String, dynamic> preferencesMap = jsonDecode(jsonString);
      preferences = UserPreferences.fromMap(data: preferencesMap);
    } else {
      preferences = null;
    }
  }

  /// Creates a new `AppUser` instance.
  AppUser({
    this.id = 0,
    required this.email,
    required this.uid,
    required this.isAnonymous,
    required this.isEmailVerified,
    this.isPhoneVerified,
    this.photoUrl,
    this.preferences,
  });

  /// Creates a copy of the current `AppUser` instance with updated values.
  AppUser copyWith({
    String? email,
    String? uid,
    bool? isAnonymous,
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

  /// Converts the `AppUser` instance to a map for serialization.
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "photoUrl": photoUrl,
      "isAnonymous": isAnonymous,
      "isEmailVerified": isEmailVerified,
      "isPhoneVerified": isPhoneVerified,
      "profile": profile.target?.toMap(),
      "preferences": preferences?.toMap() ?? UnitPreferences.metric().toMap(),
    };
  }

  /// Creates an `AppUser` instance from a map.
  factory AppUser.fromMap({required Map<String, dynamic> data}) {
    return AppUser(
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

  /// Creates an `AppUser` instance from a Firebase `User` object.
  factory AppUser.fromUser({required User? user}) {
    if (user == null) {
      return AppUser.empty;
    }
    return AppUser(
      email: user.email ?? "",
      uid: user.uid,
      isEmailVerified: user.emailVerified,
      isAnonymous: user.isAnonymous,
      photoUrl: user.photoURL,
    );
  }

  /// A predefined empty `AppUser` instance for default values.
  @Transient()
  static AppUser empty = AppUser(
    email: "",
    uid: "",
    isAnonymous: false,
    isEmailVerified: false,
    isPhoneVerified: false,
    preferences: null,
  );

  /// Checks if the current `AppUser` instance is empty.
  @Transient()
  bool get isEmpty => this == AppUser.empty;

  /// Checks if the current `AppUser` instance is not empty.
  @Transient()
  bool get isNotEmpty => this != AppUser.empty;

  /// Returns a display name for the user.
  ///
  /// Attempts to use the `displayName` or the first part of the `name` from the user's profile.
  /// Falls back to the user's email if no profile data is available.
  String getDisplayName() {
    UserProfile? uProfile = profile.target;

    if (uProfile != null) {
      if (uProfile.displayName?.isNotEmpty ?? false) {
        return uProfile.displayName!.split(" ").first;
      } else if (uProfile.name?.isNotEmpty ?? false) {
        return uProfile.name!.split(" ").first;
      }
    }

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
        phone: "+1234567890",
        bmi: 18.2,
      ),
    );
    return sampleUser;
  }

  @override
  @Transient()
  bool? get stringify => true;


  /// Enables stringification for easier debugging.
  @override
  String toString() {
    if (isEmpty) {
      return "AppUser.empty";
    }
    return super.toString();
  }

  /// List of properties for equality checks.
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
}
