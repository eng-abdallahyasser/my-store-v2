import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/data/model/app_notification.dart';
import 'package:store_app_v2/routes/my_routes.dart';

// Top-level background handler must be a static/global function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No UI work here; Android will display if provided
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Subscribe to the "all-users" topic
  Future<void> subscribeToAllUsersTopic() async {
    try {
      await _messaging.subscribeToTopic('all-users');
      print('Subscribed to all-users topic');
    } catch (e) {
      print('Error subscribing to all-users topic: $e');
    }
  }

  /// Unsubscribe from the "all-users" topic
  Future<void> unsubscribeFromAllUsersTopic() async {
    try {
      await _messaging.unsubscribeFromTopic('all-users');
      print('Unsubscribed from all-users topic');
    } catch (e) {
      print('Error unsubscribing from all-users topic: $e');
    }
  }

  Future<void> init() async {
    if (_initialized) return;
    
    // Initialize local notifications first
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          try {
            final data = json.decode(response.payload!) as Map<String, dynamic>;
            _handleNavigationFromData(data);
          } catch (e) {
            if (kDebugMode) {
              print('Error handling notification tap: $e');
            }
          }
        }
      },
    );

    // iOS/macOS permissions
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Subscribe to all-users topic
    await subscribeToAllUsersTopic();

    // Create Android notification channel with heads-up notification support
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,  // Changed from high to max for heads-up
      playSound: true,
      enableVibration: true,
      showBadge: true,
      enableLights: true,
    );


    // Android: register channel
    await _local.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    // Set background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Subscribe this device to a public topic to allow broadcasting from Firebase Console
    // e.g., send to topic 'all-users'
    try {
      await _messaging.subscribeToTopic('all-users');
    } catch (_) {}

    // Keep topic subscription on token refresh
    _messaging.onTokenRefresh.listen((_) async {
      try {
        await _messaging.subscribeToTopic('all-users');
      } catch (_) {}
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      final android = notification?.android;

      // Build local notification for foreground
      final Map<String, dynamic> data = message.data;
      final String title = notification?.title ?? data['title']?.toString() ?? 'إشعار جديد';
      final String body = notification?.body ?? data['body']?.toString() ?? '';

      // Create notification details with heads-up notification configuration
      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,  // Max importance for heads-up
        priority: Priority.high,
        icon: android?.smallIcon,
        enableVibration: true,
        styleInformation: BigTextStyleInformation(body),
        visibility: NotificationVisibility.public,
        // Set to alert once to show heads-up
        playSound: true,
        // Set category to message for better handling
        category: AndroidNotificationCategory.message,
        // Set ticker for accessibility
        ticker: title,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
      );

      await _local.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
        payload: jsonEncode(message.data),
      );

      // Optionally update in-app list via controller
      _pushToController(message);
    });

    // Notification tap when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNavigationFromData(message.data);
    });

    // App launched from terminated state via notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNavigationFromData(initialMessage.data);
    }

    _initialized = true;
  }

  Future<String?> getToken() => _messaging.getToken();

  void _pushToController(RemoteMessage message) {
    try {
      final c = Get.isRegistered<NotificationController>()
          ? Get.find<NotificationController>()
          : null;
      if (c == null) return;
      final n = AppNotification(
        id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: message.notification?.title ?? message.data['title']?.toString() ?? 'إشعار',
        body: message.notification?.body ?? message.data['body']?.toString() ?? '',
        data: Map<String, dynamic>.from(message.data),
        timestamp: message.sentTime ?? DateTime.now(),
      );
      c.addNotification(n);
    } catch (_) {}
  }

  void _handleNavigationFromData(Map<String, dynamic> data) {
    // For now, just navigate to the notifications screen
    if (Get.currentRoute != MyRoutes.notifications) {
      Get.toNamed(MyRoutes.notifications);
    }
  }
}

class NotificationController extends GetxController {
  final RxList<AppNotification> notifications = <AppNotification>[].obs;

  void addNotification(AppNotification n) {
    notifications.insert(0, n);
  }

  void markAllRead() {
    for (int i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWith(read: true);
    }
    notifications.refresh();
  }

  void clearAll() {
    notifications.clear();
  }
}
