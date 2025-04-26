import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void _notificationTapBackground(NotificationResponse notificationResponse) {
  //Todo: Do something with the notification response
  // This handles notification taps when the app is terminated
  // You can add deep linking logic here later if needed
}

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    /// Initialize timezone data with local device timezone
    tz.initializeTimeZones();

    /// Android Notifications Initialization Settings
    AndroidInitializationSettings androidInitializationSettings =
    const AndroidInitializationSettings("circle_logo");

    /// iOS Notifications Initialization Settings
    final iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'medication',
          actions: <DarwinNotificationAction>[
            /// Creates a simple action to open the app on iOS.
            /// Not super necessary because opening clicking on the notification
            /// already opens the app by default on Android ans iOS,
            /// but could be useful in the future for setting up
            /// deep linking or if we have multiple actions.
            DarwinNotificationAction.plain(
              'open',
              'take',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
        )
      ],
    );

    /// Initialization Settings
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    /// Request Permissions for Android
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    /// Initialize with notification tap handlers
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        //Todo: do something with the notification response
        // This handles notification taps when the app is in the foreground or background
        // You can add deep linking logic here later if needed
      },
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );
  }

  Future<NotificationDetails> notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails("medicationId", "Today's Medication",
            importance: Importance.max),
        iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            categoryIdentifier: "medication"));
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    await notificationsPlugin.show(id, title, body, await notificationDetails(),
        payload: payload // Can be used for deep linking later
    );
  }

  Future<void> scheduleDailyNotification({
    required DateTime selectedTime,
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async {

    try {
      notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(selectedTime, tz.local),
        await notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );

      log("Notification with title '$title' and body '$body' scheduled for ${tz.TZDateTime.from(selectedTime, tz.local)} ${tz.local}", name: "Notification Service");
    } catch (e, stacktrace) {
      log("Failed to schedule notification: ${e.toString()}",
          name: "Notification Service", stackTrace: stacktrace);
      rethrow;
    }
  }

  Future<void> scheduleNotification({
    required DateTime date,
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async {

    try {
      notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(date, tz.local),
        await notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );

      log("Notification with title '$title' and body '$body' scheduled for ${tz.TZDateTime.from(date, tz.local)} ${tz.local}", name: "Notification Service");
    } catch (e, stacktrace) {
      log("Failed to schedule notification: ${e.toString()}",
          name: "Notification Service", stackTrace: stacktrace);
      rethrow;
    }
  }
}