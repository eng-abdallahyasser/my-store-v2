import 'dart:convert';
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

  Future<void> init() async {
    if (_initialized) return;

    // iOS/macOS permissions
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Create Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
    );

    // Initialize local notifications
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          final map = jsonDecode(payload) as Map<String, dynamic>;
          _handleNavigationFromData(map);
        }
      },
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

      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: android?.smallIcon,
        ),
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
