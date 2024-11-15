import 'package:circle/features/auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:objectbox/objectbox.dart';
import '../../../../core/enums.dart';

@Entity()
// ignore: must_be_immutable
class UserProfile extends Equatable {
  ///Profile Info
  @Id()
  int id;
  String? uid;
  @Transient()
  Gender? gender;
  String? name;
  String? displayName;
  int? age;
  String? email;
  String? photoUrl;
  String? phone;
  @Transient()
  Genotype? genotype;

  /// Health Info
  int? painSeverity;
  String? crisisFrequency;
  double? height;
  double? weight;
  double? bmi;
  String? bloodGroup;
  List<String>? allergies;
  List<String>? medicalConditions;


  //Object Box Type Converters
  String? get dbGender => gender?.name;
  String? get dbGenotype => genotype?.name;

  set dbGender(String? value) {
    if (value != null) {
      gender = Gender.values.byName(value);
    } else {
      gender == null;
    }
  }

  set dbGenotype(String? value) {
    if (value != null) {
      genotype = Genotype.values.byName(value);
    } else {
      genotype == null;
    }
  }

  UserProfile(
      {
      //Profile Info
      this.id = 0,
      this.uid,
      this.gender,
      this.name,
      this.age,
      this.displayName,
      this.email,
      this.photoUrl,
      this.phone,

      //Health Info
      this.crisisFrequency,
      this.painSeverity,
      this.genotype,
      this.height,
      this.weight,
      this.bmi,
      this.bloodGroup,
      this.allergies,
      this.medicalConditions});

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
  }) {
    return UserProfile(
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
    );
  }

  //-----To and From Map-------//
  Map<String, dynamic> toMap() {
    Map<String, dynamic> profileData = {
      "uid": uid,
      "gender": gender?.name,
      "name": name,
      "displayName": displayName,
      "age": age,
      "photoUrl": photoUrl,
      "phone": phone,
      "email": email,
    };
    Map<String, dynamic> healthData = {
      "painSeverity": painSeverity,
      "crisisFrequency": crisisFrequency,
      "genotype": genotype?.name,
      "height": height,
      "weight": weight,
      "bmi": bmi,
      "bloodGroup": bloodGroup,
      "allergies": allergies,
      "medicalConditions": medicalConditions,
    };

    Map<String, Map<String, dynamic>> userData = {
      "profile": profileData,
      "health": healthData,
    };
    return userData;
  }

  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      uid: data["profile"]["uid"] as String,
      gender: Gender.values.byName(data["gender"] as String),
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
      allergies: data["health"]["allergies"] as List<String>,
      medicalConditions: data["health"]["medicalConditions"] as List<String>,
    );
  }

  factory UserProfile.fromFirebaseUser({User? user}) {
    return UserProfile(
      uid: user?.uid,
      photoUrl: user?.photoURL,
      phone: user?.phoneNumber,
      email: user?.email,
      displayName: user?.displayName,
    );
  }

  //
  double? calculateBMI() {
    if (height != null && weight != null) {
      return weight! / ((height! / 100) * (height! / 100));
    } else {
      return null;
    }
  }

  //-------------Empty----------//
@Transient()
  static UserProfile empty = UserProfile();
@Transient()
  bool get isEmpty => this == UserProfile.empty || this == UserProfile();
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
      ];
}
