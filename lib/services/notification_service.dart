import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/controller/notification_controller.dart';
import 'package:store_app_v2/data/model/app_notification.dart';
import 'package:store_app_v2/routes/my_routes.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'dart:developer';

// Top-level background handler must be a static/global function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  // Initialize the local notifications plugin
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
  );
  
  // Show local notification
  final notification = message.notification;
  if (notification != null) {
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }
  
  // Save notification to Firestore
  if (message.notification != null) {
    final appNotification = AppNotification(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'إشعار جديد',
      body: message.notification?.body ?? '',
      data: message.data,
      timestamp: message.sentTime ?? DateTime.now(),
      read: false,
    );
    
    // Save to user's notifications if there's a user ID in the data
    final userId = message.data['userId'];
    if (userId != null && userId is String) {
      await Repo.notification.saveUserNotification(userId, appNotification);
    } else {
      // Otherwise save to all users notifications
      await Repo.notification.saveAllUsersNotification(appNotification);
    }
  }
}

class NotificationService {
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  
  NotificationService._();

  /// Subscribe to the "all-users" topic
  Future<void> subscribeToAllUsersTopic() async {
    try {
      await _messaging.subscribeToTopic('all-users');
      debugPrint('Subscribed to all-users topic');
    } catch (e) {
      debugPrint('Error subscribing to all-users topic: $e');
    }
  }

  /// Unsubscribe from the "all-users" topic
  Future<void> unsubscribeFromAllUsersTopic() async {
    try {
      await _messaging.unsubscribeFromTopic('all-users');
      log('Unsubscribed from all-users topic', name: 'NotificationService');
    } catch (e) {
      log('Error unsubscribing from all-users topic: $e', name: 'NotificationService');
    }
  }

  Future<void> init() async {
    if (_initialized) return;
    
    // Request notification permissions
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    // Initialize local notifications
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          try {
            final data = json.decode(response.payload!) as Map<String, dynamic>;
            _handleNavigationFromData(data);
          } catch (e) {
            if (kDebugMode) {
              log('Error handling notification tap: $e', name: 'NotificationService');
            }
          }
        }
      },
    );

    // Create Android notification channel with heads-up notification support
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
      enableLights: true,
    );

    // Android: register channel
    await _local.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Set background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Subscribe to all-users topic
    await subscribeToAllUsersTopic();

    // Keep topic subscription on token refresh
    _messaging.onTokenRefresh.listen((_) async {
      try {
        await _messaging.subscribeToTopic('all-users');
      } catch (e) {
        if (kDebugMode) {
          log('Error refreshing token subscription: $e', name: 'NotificationService');
        }
      }
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
        importance: Importance.max,
        priority: Priority.high,
        icon: android?.smallIcon,
        enableVibration: true,
        styleInformation: BigTextStyleInformation(body),
        visibility: NotificationVisibility.public,
        playSound: true,
        category: AndroidNotificationCategory.message,
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

      // Update in-app list via controller
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

  void _pushToController(RemoteMessage message) async {
    try {
      if (!Get.isRegistered<NotificationController>()) return;
      
      final controller = Get.find<NotificationController>();
      final userId = Repo.auth.getCurrentUser()?.uid;
      
      if (userId == null) return;
      
      // The background handler already saves the notification,
      // so we just need to refresh the controller
      if (Get.isRegistered<NotificationController>()) {
        await controller.fetchNotifications();
      }
    } catch (e) {
      if (kDebugMode) {
        log('Error in _pushToController: $e', name: 'NotificationService');
      }
    }
  }

  void _handleNavigationFromData(Map<String, dynamic> data) {
    // For now, just navigate to the notifications screen
    if (Get.currentRoute != MyRoutes.notifications) {
      Get.toNamed(MyRoutes.notifications);
    }
  }
}

// NotificationController has been moved to a separate file
