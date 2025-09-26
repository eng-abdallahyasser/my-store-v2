import 'package:get/get.dart';
import 'package:store_app_v2/data/model/app_notification.dart';
import 'package:store_app_v2/data/data_source/repo.dart';

class NotificationController extends GetxController {
  final RxList<AppNotification> _userNotifications = <AppNotification>[].obs;
  final RxList<AppNotification> _allUsersNotifications = <AppNotification>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasUnread = false.obs;

  List<AppNotification> get userNotifications => _userNotifications;
  List<AppNotification> get allUsersNotifications => _allUsersNotifications;
  bool get isLoading => _isLoading.value;
  bool get hasUnread => _hasUnread.value;

  @override
  void onInit() {
    super.onInit();
    if (Repo.auth.getCurrentUser() != null) {
      fetchNotifications();
    }
  }

  Future<void> fetchNotifications() async {
    try {
      _isLoading.value = true;
      final userId = Repo.auth.getCurrentUser()!.uid;
      
      // Listen to user-specific notifications
      Repo.notification.getUserNotifications(userId).listen((notifications) {
        _userNotifications.value = notifications;
        _checkUnreadStatus();
      });

      // Listen to all users notifications
      Repo.notification.getAllUsersNotifications().listen((notifications) {
        _allUsersNotifications.value = notifications;
        _checkUnreadStatus();
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch notifications: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> markAsRead(String notificationId, {bool isUserSpecific = true}) async {
    try {
      if (isUserSpecific) {
        final userId = Repo.auth.getCurrentUser()!.uid;
        await Repo.notification.markAsRead(userId, notificationId);
      }
      // For all users notifications, we don't mark as read since they're shared
      _checkUnreadStatus();
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final userId = Repo.auth.getCurrentUser()!.uid;
      await Repo.notification.markAllAsRead(userId);
      _hasUnread.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark all notifications as read: $e');
    }
  }

  void _checkUnreadStatus() {
    final hasUnreadUserNotifications = _userNotifications.any((n) => !n.read);
    _hasUnread.value = hasUnreadUserNotifications;
  }

  // Get all notifications sorted by timestamp (newest first)
  List<AppNotification> get allNotifications {
    final all = [..._userNotifications, ..._allUsersNotifications];
    all.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return all;
  }

  // Group notifications by date
  Map<DateTime, List<AppNotification>> get groupedNotifications {
    final Map<DateTime, List<AppNotification>> grouped = {};
    
    for (final notification in allNotifications) {
      final date = DateTime(
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
      );
      
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(notification);
    }
    
    return Map.fromEntries(
      grouped.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key)),
    );
  }
}
