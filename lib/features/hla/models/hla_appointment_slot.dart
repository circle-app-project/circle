import 'package:equatable/equatable.dart';

/// A bookable, admin-defined collection slot. Patients pick one of these to
/// come hand over their sample.
///
/// Lives only in Firestore (`hla_appointment_slots/{id}`) — there is no local
/// ObjectBox copy for the MVP. Booking and cancelling adjust [bookedCount]
/// inside a Firestore transaction so a slot can never be over-booked.
class HlaAppointmentSlot extends Equatable {
  /// Firestore document id (a uuid).
  final String id;

  /// When the collection happens.
  final DateTime dateTime;

  /// Where the patient should come (clinic name / address).
  final String location;

  /// Maximum number of bookings this slot can take.
  final int capacity;

  /// How many bookings have been taken so far.
  final int bookedCount;

  /// Whether the slot is offered to patients. Deactivating hides it without
  /// deleting history.
  final bool isActive;

  const HlaAppointmentSlot({
    required this.id,
    required this.dateTime,
    required this.location,
    required this.capacity,
    this.bookedCount = 0,
    this.isActive = true,
  });

  /// A slot is bookable when it is active, has remaining capacity, and is in
  /// the future.
  bool get isAvailable =>
      isActive && bookedCount < capacity && dateTime.isAfter(DateTime.now());

  int get remainingSeats => (capacity - bookedCount).clamp(0, capacity);

  HlaAppointmentSlot copyWith({
    String? id,
    DateTime? dateTime,
    String? location,
    int? capacity,
    int? bookedCount,
    bool? isActive,
  }) {
    return HlaAppointmentSlot(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      capacity: capacity ?? this.capacity,
      bookedCount: bookedCount ?? this.bookedCount,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "dateTime": dateTime.toUtc().toIso8601String(),
      "location": location,
      "capacity": capacity,
      "bookedCount": bookedCount,
      "isActive": isActive,
    };
  }

  factory HlaAppointmentSlot.fromMap(Map<String, dynamic> map) {
    return HlaAppointmentSlot(
      id: map["id"] as String,
      dateTime: DateTime.parse(map["dateTime"] as String),
      location: map["location"] as String,
      capacity: (map["capacity"] as num).toInt(),
      bookedCount: (map["bookedCount"] as num?)?.toInt() ?? 0,
      isActive: map["isActive"] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props =>
      [id, dateTime, location, capacity, bookedCount, isActive];
}
