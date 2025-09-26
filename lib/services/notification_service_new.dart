import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/data/model/app_notification.dart';

// Top-level background handler must be a static/global function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Save notification to Firestore
  if (message.notification != null) {
    final notification = AppNotification(
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
      await Repo.notification.saveUserNotification(userId, notification);
    } else {
      // Otherwise save to all users notifications
      await Repo.notification.saveAllUsersNotification(notification);
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
      debugPrint('Unsubscribed from all-users topic');
    } catch (e) {
      debugPrint('Error unsubscribing from all-users topic: $e');
    }
  }

  /// Initialize the notification service
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
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit, 
      iOS: iosInit,
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        if (response.payload != null) {
          _handleNotificationTap(jsonDecode(response.payload!));
        }
      },
    );

    // Set up foreground message handler
    FirebaseMessaging.onMessage.listen(_onMessage);
    
    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    
    // Handle notification when app is terminated and opened
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage.data);
    }
    
    // Handle notification when app is in background and opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message.data);
    });
    
    _initialized = true;
  }

  /// Handle when notification is received while app is in foreground
  void _onMessage(RemoteMessage message) async {
    if (message.notification != null) {
      final notification = AppNotification(
        id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: message.notification?.title ?? 'إشعار جديد',
        body: message.notification?.body ?? '',
        data: message.data,
        timestamp: message.sentTime ?? DateTime.now(),
        read: false,
      );
      
      // Save to Firestore
      try {
        final userId = message.data['userId'];
        if (userId != null && userId is String) {
          await Repo.notification.saveUserNotification(userId, notification);
        } else {
          await Repo.notification.saveAllUsersNotification(notification);
        }
      } catch (e) {
        debugPrint('Error saving notification in onMessage: $e');
      }
      
      // Show local notification
      await _showLocalNotification(notification);
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(AppNotification notification) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'إشعارات التطبيق',
      channelDescription: 'قناة الإشعارات الافتراضية',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _local.show(
      notification.id.hashCode,
      notification.title,
      notification.body,
      platformDetails,
      payload: jsonEncode(notification.data),
    );
  }

  /// Handle notification tap
  void _handleNotificationTap(Map<String, dynamic> data) {
    // Handle different notification types based on data
    // For example:
    // if (data['type'] == 'order') {
    //   Get.toNamed(MyRoutes.orderDetails, arguments: data['orderId']);
    // }
  }
  
  /// Get FCM token
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }
}
