import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    try {
      final messaging = FirebaseMessaging.instance;
      
      // Request permission on iOS & Android 13+
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (kDebugMode) {
        print('User notification permission status: ${settings.authorizationStatus}');
      }

      // Subscribe to daily devotional and festival broadcast topic
      await messaging.subscribeToTopic('devotional_updates');
      await messaging.subscribeToTopic('festival_alerts');

      // Listen to foreground notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('Foreground notification received: ${message.notification?.title}');
        }
      });
    } catch (_) {
      // Offline or Firebase not initialized on platform
    }
  }
}
