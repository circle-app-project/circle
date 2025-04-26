import 'dart:developer';

import 'package:circle/features/meds/models/scheduled_doses.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/core.dart';
import '../models/medication.dart';
import '../services/local/notification_service.dart';

class NotificationRepository {
  final NotificationService _notificationService;

  NotificationRepository({required NotificationService notificationService})
    : _notificationService = notificationService;

  Future<void> initialize() async {
    try {
      log(
        "Initialising Notification Service...",
        name: "Notification Repository",
      );
      await _notificationService.initialize();
      log("Initialised Notification", name: "Notification Repository");
    } catch (e, stackTrace) {
      log(
        "Failed to initialise Notifications: ${e.toString()} ",
        name: "Notification Repository",
        stackTrace: stackTrace,
      );
    }
  }

  Future<Either<Failure, void>> scheduleMedDosesNotifications({
    required List<ScheduledDose> doses,
    required Medication medication,
  }) async {
    try {
      for (ScheduledDose dose in doses) {
        await _notificationService.scheduleNotification(
          date: dose.date,
          id: generateUniqueId(
            data: dose.uid.toString(),
            date: dose.date,
          ),
          title: "Time to take your medication 😊",
          body:
              medication.reminderMessage ??
              "It's time to take ${medication.name}",
        );
      }

      return const Right(null);
    } catch (e, stackTrace) {
      log(
        "Failed to schedule notifications for medication : ${e.toString()}",
        name: "Notification Repository",
        stackTrace: stackTrace,
      );

      return Left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Checks if a [DateTime] is between a given start date and end date.
  /// Returns true if a [DateTime] is on the same day as the start date
  /// or if a [DateTime] is on the same day as the end date
  /// And also if a [DateTime] falls between the start date and end date
  ///
  /// So this takes control of "edge dates"
  ///
  /// Important, this method does not consider time, only dates.
  bool isDateBetween({
    required DateTime startDate,
    DateTime? endDate,
    required DateTime date,
  }) {
    startDate = startDate.copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    if (endDate != null) {
      endDate = endDate.copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

      return isSameDay(startDate, date) ||
          (date.isAfter(startDate) && date.isBefore(endDate)) ||
          isSameDay(endDate, date);
    }

    return isSameDay(startDate, date);
  }

  /// Generates a unique integer id which can be used for providing a
  /// specific id to each notification.
  /// Having duplicate ids for notifications will cause the notification
  /// to be overridden by the other, so this is very much necessary
  int generateUniqueId({required String data, required DateTime date}) {
    String dataRaw = data + date.toIso8601String();
    return dataRaw.hashCode;
  }
}
