import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

import '../../../core/utils/enums.dart';
import 'hla_sample_subject.dart';
import 'hla_status_event.dart';

/// A patient's request for an HLA typing test and the full state of its
/// journey — the panel of sample subjects, the booked collection appointment,
/// the status history, and (once ready) the uploaded results.
///
/// Persists with ObjectBox. Complex fields (`status`, `subjects`,
/// `statusHistory`) are `@Transient` and stored as strings via the
/// `db*` converters — the same approach `Medication` uses for `Dose` and
/// `Frequency`. Firestore is the realtime source of truth (see plan §D5); the
/// local box is an optional cache.
@Entity()
// ignore: must_be_immutable
class HlaTestRequest extends Equatable {
  /// ObjectBox auto-id.
  @Id()
  int id;

  /// Stable request id (uuid) — also the Firestore document id.
  @Unique(onConflict: ConflictStrategy.replace)
  final String uid;

  /// The owning patient's Firebase uid.
  final String userId;

  /// Patient's display name, denormalized so the admin queue can render
  /// without an extra user lookup.
  final String patientName;

  /// Current status. Stored as a string via [dbStatus].
  @Transient()
  HlaTestStatus status;

  /// The cross-match panel. Stored as a JSON string via [dbSubjects].
  @Transient()
  List<HlaSampleSubject> subjects;

  /// Append-only history of status changes. Stored as JSON via
  /// [dbStatusHistory].
  @Transient()
  List<HlaStatusEvent> statusHistory;

  /// Booked appointment fields (null until a slot is chosen).
  final String? appointmentSlotId;
  @Property(type: PropertyType.date)
  final DateTime? appointmentDate;
  final String? collectionLocation;

  /// Result fields (null until staff upload them).
  final String? resultFileUrl;
  final String? resultFileName;
  final String? resultSummary;

  /// Admin-only free-text notes.
  final String? adminNotes;

  final bool isCancelled;

  @Property(type: PropertyType.date)
  final DateTime? createdAt;
  @Property(type: PropertyType.date)
  final DateTime? updatedAt;

  /// ----- OBJECTBOX TYPE CONVERTERS ----- ///

  String get dbStatus => status.name;
  set dbStatus(String value) {
    status = HlaTestStatus.values.byName(value);
  }

  String get dbSubjects =>
      jsonEncode(subjects.map((s) => s.toMap()).toList());
  set dbSubjects(String value) {
    if (value.isEmpty) {
      subjects = [];
      return;
    }
    final List<dynamic> decoded = jsonDecode(value) as List<dynamic>;
    subjects = decoded
        .map((e) => HlaSampleSubject.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  String get dbStatusHistory =>
      jsonEncode(statusHistory.map((e) => e.toMap()).toList());
  set dbStatusHistory(String value) {
    if (value.isEmpty) {
      statusHistory = [];
      return;
    }
    final List<dynamic> decoded = jsonDecode(value) as List<dynamic>;
    statusHistory = decoded
        .map((e) => HlaStatusEvent.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  HlaTestRequest({
    this.id = 0,
    required this.uid,
    required this.userId,
    required this.patientName,
    this.status = HlaTestStatus.requested,
    List<HlaSampleSubject>? subjects,
    List<HlaStatusEvent>? statusHistory,
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
  })  : subjects = subjects ?? [],
        statusHistory = statusHistory ?? [];

  HlaTestRequest copyWith({
    String? userId,
    String? patientName,
    HlaTestStatus? status,
    List<HlaSampleSubject>? subjects,
    List<HlaStatusEvent>? statusHistory,
    String? appointmentSlotId,
    DateTime? appointmentDate,
    String? collectionLocation,
    String? resultFileUrl,
    String? resultFileName,
    String? resultSummary,
    String? adminNotes,
    bool? isCancelled,
    DateTime? updatedAt,
  }) {
    return HlaTestRequest(
      id: id,
      uid: uid,
      userId: userId ?? this.userId,
      patientName: patientName ?? this.patientName,
      status: status ?? this.status,
      subjects: subjects ?? this.subjects,
      statusHistory: statusHistory ?? this.statusHistory,
      appointmentSlotId: appointmentSlotId ?? this.appointmentSlotId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      collectionLocation: collectionLocation ?? this.collectionLocation,
      resultFileUrl: resultFileUrl ?? this.resultFileUrl,
      resultFileName: resultFileName ?? this.resultFileName,
      resultSummary: resultSummary ?? this.resultSummary,
      adminNotes: adminNotes ?? this.adminNotes,
      isCancelled: isCancelled ?? this.isCancelled,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": uid,
      "userId": userId,
      "patientName": patientName,
      "status": status.name,
      "subjects": subjects.map((s) => s.toMap()).toList(),
      "statusHistory": statusHistory.map((e) => e.toMap()).toList(),
      "appointmentSlotId": appointmentSlotId,
      "appointmentDate": appointmentDate?.toUtc().toIso8601String(),
      "collectionLocation": collectionLocation,
      "resultFileUrl": resultFileUrl,
      "resultFileName": resultFileName,
      "resultSummary": resultSummary,
      "adminNotes": adminNotes,
      "isCancelled": isCancelled,
      "createdAt": createdAt?.toUtc().toIso8601String(),
      "updatedAt": updatedAt?.toUtc().toIso8601String(),
    };
  }

  factory HlaTestRequest.fromMap(Map<String, dynamic> map) {
    return HlaTestRequest(
      uid: map["id"] as String,
      userId: map["userId"] as String,
      patientName: (map["patientName"] as String?) ?? "",
      status: HlaTestStatus.values.byName(map["status"] as String),
      subjects: ((map["subjects"] as List<dynamic>?) ?? [])
          .map((e) => HlaSampleSubject.fromMap(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList(),
      statusHistory: ((map["statusHistory"] as List<dynamic>?) ?? [])
          .map((e) => HlaStatusEvent.fromMap(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList(),
      appointmentSlotId: map["appointmentSlotId"] as String?,
      appointmentDate: map["appointmentDate"] != null
          ? DateTime.parse(map["appointmentDate"] as String)
          : null,
      collectionLocation: map["collectionLocation"] as String?,
      resultFileUrl: map["resultFileUrl"] as String?,
      resultFileName: map["resultFileName"] as String?,
      resultSummary: map["resultSummary"] as String?,
      adminNotes: map["adminNotes"] as String?,
      isCancelled: map["isCancelled"] as bool? ?? false,
      createdAt: map["createdAt"] != null
          ? DateTime.parse(map["createdAt"] as String)
          : null,
      updatedAt: map["updatedAt"] != null
          ? DateTime.parse(map["updatedAt"] as String)
          : null,
    );
  }

  /// Whether results can be viewed by the patient.
  bool get hasResults => status.isResultsReady && resultFileUrl != null;

  @Transient()
  static HlaTestRequest empty = HlaTestRequest(
    uid: "",
    userId: "",
    patientName: "",
  );

  @Transient()
  bool get isEmpty => uid.isEmpty;

  @Transient()
  bool get isNotEmpty => uid.isNotEmpty;

  @override
  @Transient()
  bool? get stringify => true;

  @override
  @Transient()
  List<Object?> get props => [
        id,
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
