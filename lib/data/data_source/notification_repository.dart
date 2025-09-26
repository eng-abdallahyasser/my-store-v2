import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/model/app_notification.dart';
import 'package:store_app_v2/data/data_source/base_repository.dart';

class NotificationRepository extends BaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';
  final String _notificationsSubCollection = 'notifications';
  final String _allUsersCollection = 'all_users_notifications';

  // Get stream of user-specific notifications
  Stream<List<AppNotification>> getUserNotifications(String userId) {
    return _firestore
        .collection(_collection)
        .doc(userId)
        .collection(_notificationsSubCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppNotification.fromMap({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  // Get stream of general notifications for all users
  Stream<List<AppNotification>> getAllUsersNotifications() {
    return _firestore
        .collection(_allUsersCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppNotification.fromMap({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  // Mark a notification as read
  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(userId)
          .collection(_notificationsSubCollection)
          .doc(notificationId)
          .update({'read': true});
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final notifications = await _firestore
          .collection(_collection)
          .doc(userId)
          .collection(_notificationsSubCollection)
          .where('read', isEqualTo: false)
          .get();

      for (var doc in notifications.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  // Save a notification for a specific user
  Future<void> saveUserNotification(String userId, AppNotification notification) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(userId)
          .collection(_notificationsSubCollection)
          .doc(notification.id)
          .set(notification.toMap());
    } catch (e) {
      throw Exception('Failed to save user notification: $e');
    }
  }

  // Save a notification for all users
  Future<void> saveAllUsersNotification(AppNotification notification) async {
    try {
      await _firestore
          .collection(_allUsersCollection)
          .doc(notification.id)
          .set(notification.toMap());
    } catch (e) {
      throw Exception('Failed to save all users notification: $e');
    }
  }
}
