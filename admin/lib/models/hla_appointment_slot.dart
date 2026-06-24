import 'package:equatable/equatable.dart';

/// A bookable collection slot. Mirrors the mobile `HlaAppointmentSlot`.
class HlaAppointmentSlot extends Equatable {
  const HlaAppointmentSlot({
    required this.id,
    required this.dateTime,
    required this.location,
    required this.capacity,
    this.bookedCount = 0,
    this.isActive = true,
  });

  final String id;
  final DateTime dateTime;
  final String location;
  final int capacity;
  final int bookedCount;
  final bool isActive;

  int get remainingSeats => (capacity - bookedCount).clamp(0, capacity);

  bool get isFull => bookedCount >= capacity;

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

  Map<String, dynamic> toMap() => {
        'id': id,
        'dateTime': dateTime.toUtc().toIso8601String(),
        'location': location,
        'capacity': capacity,
        'bookedCount': bookedCount,
        'isActive': isActive,
      };

  factory HlaAppointmentSlot.fromMap(Map<String, dynamic> map) {
    return HlaAppointmentSlot(
      id: (map['id'] as String?) ?? '',
      dateTime:
          DateTime.tryParse(map['dateTime'] as String? ?? '') ?? DateTime.now(),
      location: (map['location'] as String?) ?? '',
      capacity: (map['capacity'] as num?)?.toInt() ?? 0,
      bookedCount: (map['bookedCount'] as num?)?.toInt() ?? 0,
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props =>
      [id, dateTime, location, capacity, bookedCount, isActive];
}
