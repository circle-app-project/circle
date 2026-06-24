import 'package:equatable/equatable.dart';

import '../core/enums.dart';
import 'hla_sample_subject.dart';
import 'hla_status_event.dart';

/// A patient's HLA typing request, as stored in `hla_test_requests/{id}`.
/// Serialization mirrors the mobile `HlaTestRequest` so the same documents
/// round-trip between both apps. ObjectBox is intentionally absent here.
class HlaTestRequest extends Equatable {
  const HlaTestRequest({
    required this.uid,
    required this.userId,
    required this.patientName,
    this.status = HlaTestStatus.requested,
    this.subjects = const [],
    this.statusHistory = const [],
    this.appointmentSlotId,
    this.appointmentDate,
    this.collectionLocation,
    this.resultFileUrl,
    this.resultFileName,
    this.resultSummary,
    this.adminNotes,
    this.isCancelled = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Firestore document id (the mobile app stores it under the `id` key).
  final String uid;
  final String userId;
  final String patientName;
  final HlaTestStatus status;
  final List<HlaSampleSubject> subjects;
  final List<HlaStatusEvent> statusHistory;
  final String? appointmentSlotId;
  final DateTime? appointmentDate;
  final String? collectionLocation;
  final String? resultFileUrl;
  final String? resultFileName;
  final String? resultSummary;
  final String? adminNotes;
  final bool isCancelled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get hasResults => status.isResultsReady && resultFileUrl != null;

  HlaTestRequest copyWith({
    HlaTestStatus? status,
    List<HlaStatusEvent>? statusHistory,
    String? resultFileUrl,
    String? resultFileName,
    String? resultSummary,
    String? adminNotes,
    bool? isCancelled,
    DateTime? updatedAt,
  }) {
    return HlaTestRequest(
      uid: uid,
      userId: userId,
      patientName: patientName,
      status: status ?? this.status,
      subjects: subjects,
      statusHistory: statusHistory ?? this.statusHistory,
      appointmentSlotId: appointmentSlotId,
      appointmentDate: appointmentDate,
      collectionLocation: collectionLocation,
      resultFileUrl: resultFileUrl ?? this.resultFileUrl,
      resultFileName: resultFileName ?? this.resultFileName,
      resultSummary: resultSummary ?? this.resultSummary,
      adminNotes: adminNotes ?? this.adminNotes,
      isCancelled: isCancelled ?? this.isCancelled,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': uid,
        'userId': userId,
        'patientName': patientName,
        'status': status.name,
        'subjects': subjects.map((s) => s.toMap()).toList(),
        'statusHistory': statusHistory.map((e) => e.toMap()).toList(),
        'appointmentSlotId': appointmentSlotId,
        'appointmentDate': appointmentDate?.toUtc().toIso8601String(),
        'collectionLocation': collectionLocation,
        'resultFileUrl': resultFileUrl,
        'resultFileName': resultFileName,
        'resultSummary': resultSummary,
        'adminNotes': adminNotes,
        'isCancelled': isCancelled,
        'createdAt': createdAt?.toUtc().toIso8601String(),
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
      };

  factory HlaTestRequest.fromMap(Map<String, dynamic> map) {
    List<T> parseList<T>(dynamic raw, T Function(Map<String, dynamic>) fromMap) {
      if (raw is! List) return <T>[];
      return raw
          .map((e) => fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return HlaTestRequest(
      uid: (map['id'] as String?) ?? '',
      userId: (map['userId'] as String?) ?? '',
      patientName: (map['patientName'] as String?) ?? '',
      status: HlaTestStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => HlaTestStatus.requested,
      ),
      subjects: parseList(map['subjects'], HlaSampleSubject.fromMap),
      statusHistory: parseList(map['statusHistory'], HlaStatusEvent.fromMap),
      appointmentSlotId: map['appointmentSlotId'] as String?,
      appointmentDate: map['appointmentDate'] != null
          ? DateTime.tryParse(map['appointmentDate'] as String)
          : null,
      collectionLocation: map['collectionLocation'] as String?,
      resultFileUrl: map['resultFileUrl'] as String?,
      resultFileName: map['resultFileName'] as String?,
      resultSummary: map['resultSummary'] as String?,
      adminNotes: map['adminNotes'] as String?,
      isCancelled: map['isCancelled'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        userId,
        patientName,
        status,
        subjects,
        statusHistory,
        appointmentSlotId,
        appointmentDate,
        collectionLocation,
        resultFileUrl,
        resultFileName,
        resultSummary,
        adminNotes,
        isCancelled,
        createdAt,
        updatedAt,
      ];
}
