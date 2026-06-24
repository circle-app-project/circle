import 'package:equatable/equatable.dart';

import '../core/enums.dart';

/// One person in the cross-match panel. Mirrors the mobile `HlaSampleSubject`
/// serialization. Genotype is kept as the raw string the mobile app stored
/// (the admin only displays it), avoiding a duplicated Genotype enum.
class HlaSampleSubject extends Equatable {
  const HlaSampleSubject({
    required this.name,
    required this.relation,
    this.dob,
    this.genotype,
    this.phone,
  });

  final String name;
  final HlaSubjectRelation relation;
  final DateTime? dob;
  final String? genotype;
  final String? phone;

  bool get isSelf => relation == HlaSubjectRelation.self;

  Map<String, dynamic> toMap() => {
        'name': name,
        'relation': relation.name,
        'dob': dob?.toUtc().toIso8601String(),
        'genotype': genotype,
        'phone': phone,
      };

  factory HlaSampleSubject.fromMap(Map<String, dynamic> map) {
    return HlaSampleSubject(
      name: (map['name'] as String?) ?? '',
      relation: HlaSubjectRelation.fromName(map['relation'] as String?),
      dob: map['dob'] != null ? DateTime.tryParse(map['dob'] as String) : null,
      genotype: map['genotype'] as String?,
      phone: map['phone'] as String?,
    );
  }

  @override
  List<Object?> get props => [name, relation, dob, genotype, phone];
}
