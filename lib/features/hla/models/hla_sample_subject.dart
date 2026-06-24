import 'package:equatable/equatable.dart';

import '../../../core/utils/enums.dart';

/// A single person whose sample is collected and cross-matched as part of an
/// HLA typing request — the patient themselves, a relative, or a potential
/// donor.
///
/// This is a plain Dart model (not an ObjectBox entity). Subjects ride along
/// inside [HlaTestRequest] as a JSON-encoded list, the same way [Dose] and
/// [Frequency] are stored inside `Medication`.
class HlaSampleSubject extends Equatable {
  /// The subject's name. Required.
  final String name;

  /// Relationship to the requesting patient.
  final HlaSubjectRelation relation;

  /// Optional date of birth.
  final DateTime? dob;

  /// Optional known genotype.
  final Genotype? genotype;

  /// Optional contact phone number.
  final String? phone;

  const HlaSampleSubject({
    required this.name,
    required this.relation,
    this.dob,
    this.genotype,
    this.phone,
  });

  /// The primary subject is always the patient themselves.
  factory HlaSampleSubject.self({String name = "Me", Genotype? genotype}) {
    return HlaSampleSubject(
      name: name,
      relation: HlaSubjectRelation.self,
      genotype: genotype,
    );
  }

  HlaSampleSubject copyWith({
    String? name,
    HlaSubjectRelation? relation,
    DateTime? dob,
    Genotype? genotype,
    String? phone,
  }) {
    return HlaSampleSubject(
      name: name ?? this.name,
      relation: relation ?? this.relation,
      dob: dob ?? this.dob,
      genotype: genotype ?? this.genotype,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "relation": relation.name,
      "dob": dob?.toUtc().toIso8601String(),
      "genotype": genotype?.name,
      "phone": phone,
    };
  }

  factory HlaSampleSubject.fromMap(Map<String, dynamic> map) {
    return HlaSampleSubject(
      name: map["name"] as String,
      relation: HlaSubjectRelation.values.byName(map["relation"] as String),
      dob: map["dob"] != null ? DateTime.parse(map["dob"] as String) : null,
      genotype: map["genotype"] != null
          ? Genotype.values.byName(map["genotype"] as String)
          : null,
      phone: map["phone"] as String?,
    );
  }

  bool get isSelf => relation == HlaSubjectRelation.self;

  @override
  List<Object?> get props => [name, relation, dob, genotype, phone];
}
