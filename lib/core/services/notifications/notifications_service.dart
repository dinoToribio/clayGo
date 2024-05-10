import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Instance of Flutternotification plugin
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void init() {
    // Initialization setting for android
    const InitializationSettings initializationSettingsAndroid =
        InitializationSettings(
      android: AndroidInitializationSettings("app_icon"),
    );
    _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      // to handle event when we receive notification
      onDidReceiveNotificationResponse: (details) {
        if (details.input != null) {
          debugPrint("dino we received something");
        }
      },
    );
  }

  static Future<void> show({
    required int notifId,
    required String message,
    required String title,
  }) async {
    // To display the notification in device
    try {
      NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          "claygo_table_notif",
          "ClayGo App",
          groupKey: "gfg",
          importance: Importance.max,
          playSound: true,
          priority: Priority.high,
        ),
      );
      await _notificationsPlugin.show(
        notifId,
        title,
        message,
        notificationDetails,
      );
    } catch (e) {
      debugPrint("$e");
    }
  }
}
