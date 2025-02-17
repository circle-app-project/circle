import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:objectbox/objectbox.dart';
import '../../../../core/utils/enums.dart';

/// Represents a user's profile, combining personal details and health information.
/// This class integrates with ObjectBox for local persistence and Firebase Authentication
/// for remote user data, providing a comprehensive model of user data.
///
/// Key Features:
/// - Stores personal profile information such as name, age, and contact details.
/// - Maintains health-related metrics like BMI, height, weight, and genotype.
/// - Supports Firebase user data mapping.
/// - Implements type converters for ObjectBox to handle enums.
/// - Provides utility methods like `copyWith` and `calculateBMI`.
///
/// Note: This class uses `Equatable` for easier comparison and implements
/// `@Transient` annotations for fields that should not be persisted in ObjectBox.
@Entity()
// ignore: must_be_immutable
class UserProfile extends Equatable {
  /// Unique identifier for ObjectBox entity.
  @Id()
  int id;

  /// Firebase unique user ID, with ObjectBox enforcing unique constraints.
  @Unique(onConflict: ConflictStrategy.replace)
  String? uid;

  /// The user's gender (e.g., Male, Female), stored as an enum but converted for persistence.
  @Transient()
  Gender? gender;

  /// User's full name.
  String? name;

  /// Display name for the user, often used in app interfaces.
  String? displayName;

  /// User's age in years.
  int? age;

  /// Email address associated with the user.
  String? email;

  /// URL to the user's profile photo.
  String? photoUrl;

  /// Phone number of the user.
  String? phone;

  /// The user's genotype (e.g., AA, AS, SS), stored as an enum but converted for persistence.
  @Transient()
  Genotype? genotype;

  // Health Info
  /// User's self-reported pain severity level.
  int? painSeverity;

  /// Frequency of health crises experienced by the user.
  String? crisisFrequency;

  /// Height of the user in centimeters.
  double? height;

  /// Weight of the user in kilograms.
  double? weight;

  /// Body Mass Index (BMI) calculated from height and weight.
  double? bmi;

  /// User's blood group (e.g., A+, O-).
  String? bloodGroup;

  /// List of allergies the user has reported.
  List<String>? allergies;

  /// List of medical conditions the user has reported.
  List<String>? medicalConditions;

  // Sync Related Fields
  final bool isDeleted;
  final bool isSynced;
  @Property(type: PropertyType.date)
  final DateTime? updatedAt;
  @Property(type: PropertyType.date)
  final DateTime? createdAt;

  /// ----- OBJECTBOX TYPE CONVERTERS ----- ///
  ///
  /// Converts the gender enum to a string for database persistence.
  String? get dbGender => gender?.name;

  /// Converts the genotype enum to a string for database persistence.
  String? get dbGenotype => genotype?.name;

  /// Maps a string to the gender enum for database retrieval.
  set dbGender(String? value) {
    if (value != null) {
      gender = Gender.values.byName(value);
    } else {
      gender = null;
    }
  }

  /// Maps a string to the genotype enum for database retrieval.
  set dbGenotype(String? value) {
    if (value != null) {
      genotype = Genotype.values.byName(value);
    } else {
      genotype = null;
    }
  }

  /// Constructor for creating a [UserProfile] instance.
  UserProfile({
    // Profile Info
    this.id = 0,
    this.uid,
    this.gender,
    this.name,
    this.age,
    this.displayName,
    this.email,
    this.photoUrl,
    this.phone,

    // Health Info
    this.crisisFrequency,
    this.painSeverity,
    this.genotype,
    this.height,
    this.weight,
    this.bmi,
    this.bloodGroup,
    this.allergies,
    this.medicalConditions,

    // Sync Related Fields
    this.isDeleted = false,
    this.isSynced = false,
    this.updatedAt,
    this.createdAt,
  });

  /// Creates a copy of this [UserProfile] with optional modifications.
  UserProfile copyWith({
    String? uid,
    Gender? gender,
    String? name,
    String? displayName,
    int? age,
    String? email,
    String? photoUrl,
    String? phone,
    Genotype? genotype,
    int? painSeverity,
    String? crisisFrequency,
    double? height,
    double? weight,
    double? bmi,
    String? bloodGroup,
    List<String>? allergies,
    List<String>? medicalConditions,

    // Sync Related Fields
    bool? isDeleted,
    bool? isSynced,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      uid: uid ?? this.uid,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      painSeverity: painSeverity ?? this.painSeverity,
      crisisFrequency: crisisFrequency ?? this.crisisFrequency,
      genotype: genotype ?? this.genotype,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bmi: bmi ?? this.bmi,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      medicalConditions: medicalConditions ?? this.medicalConditions,

      // Sync Related Fields
      isDeleted: isDeleted ?? this.isDeleted,
      isSynced: isSynced ?? this.isSynced,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts this user profile to a map structure for serialization.
  Map<String, dynamic> toMap() {
    return {
      "profile": {
        "uid": uid,
        "gender": gender?.name,
        "name": name,
        "displayName": displayName,
        "age": age,
        "photoUrl": photoUrl,
        "phone": phone,
        "email": email,
      },
      "health": {
        "painSeverity": painSeverity,
        "crisisFrequency": crisisFrequency,
        "genotype": genotype?.name,
        "height": height,
        "weight": weight,
        "bmi": bmi,
        "bloodGroup": bloodGroup,
        "allergies": allergies,
        "medicalConditions": medicalConditions,
      },
      "sync": {
        "isDeleted": isDeleted,
        "isSynced": isSynced,
        "updatedAt": updatedAt?.toUtc().toIso8601String(),
        "createdAt": createdAt?.toUtc().toIso8601String(),
      },
    };
  }

  /// Creates a [UserProfile] instance from a serialized map.
  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      uid: data["profile"]["uid"] as String,
      gender: Gender.values.byName(data["profile"]["gender"] as String),
      name: data["profile"]["name"] as String,
      displayName: data["profile"]["displayName"] as String?,
      age: data["profile"]["age"] as int,
      painSeverity: data["health"]["painSeverity"] as int?,
      crisisFrequency: data["health"]["crisisFrequency"] as String?,
      genotype: Genotype.values.byName(data["health"]["genotype"] as String),
      height: data["health"]["height"] as double?,
      weight: data["health"]["weight"] as double?,
      bmi: data["health"]["bmi"] as double?,
      bloodGroup: data["health"]["bloodGroup"] as String?,
      allergies: List<String>.from(data["health"]["allergies"] as List),
      medicalConditions: List<String>.from(
        data["health"]["medicalConditions"] as List,
      ),
      isDeleted: data["sync"]["isDeleted"] as bool,
      isSynced: data["sync"]["isSynced"] as bool,
      updatedAt: DateTime.parse(data["sync"]["updatedAt"] as String),
      createdAt: DateTime.parse(data["sync"]["createdAt"] as String),
    );
  }

  /// Constructs a [UserProfile] from a Firebase [User].
  factory UserProfile.fromFirebaseUser({User? user}) {
    return UserProfile(
      uid: user?.uid,
      photoUrl: user?.photoURL,
      phone: user?.phoneNumber,
      email: user?.email,
      displayName: user?.displayName,
      createdAt: DateTime.now(), // If I am signing in, then should I overide this??
      updatedAt: DateTime.now(),
      isDeleted: false,
      isSynced: false,
    );
  }

  /// Calculates BMI from the user's height and weight.
  double? calculateBMI() {
    if (height != null && weight != null) {
      return weight! / ((height! / 100) * (height! / 100));
    } else {
      return null;
    }
  }

  /// A static empty instance representing an uninitialized user profile.
  @Transient()
  static UserProfile empty = UserProfile();

  /// Checks if the profile is uninitialized or empty.
  @Transient()
  bool get isEmpty => this == UserProfile.empty || this == UserProfile();

  /// Checks if the profile contains data.
  @Transient()
  bool get isNotEmpty => this != UserProfile.empty;

  @override
  String toString() {
    if (this == UserProfile.empty) {
      return "UserProfile.empty";
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
    uid,
    name,
    displayName,
    age,
    gender,
    genotype,
    height,
    weight,
    bmi,
    bloodGroup,
    allergies,
    medicalConditions,
    isDeleted,
    isSynced,
    updatedAt,
    createdAt,

  ];
}
