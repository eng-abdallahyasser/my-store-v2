import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_app_v2/controller/notification_controller.dart';
import 'package:store_app_v2/data/model/app_notification.dart';
import 'package:store_app_v2/view/widgets/custom_app_bar.dart';
import 'package:store_app_v2/view/widgets/loading_indicator.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final NotificationController _controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'الإشعارات',
        actions: [
          Obx(() {
            if (_controller.allNotifications.any((n) => !n.read)) {
              return TextButton(
                onPressed: _controller.markAllAsRead,
                child: const Text('تعيين الكل كمقروء'),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading) {
          return const Center(child: LoadingIndicator());
        }

        final groupedNotifications = _controller.groupedNotifications;

        if (groupedNotifications.isEmpty) {
          return const Center(
            child: Text('لا توجد إشعارات'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: groupedNotifications.length,
          itemBuilder: (context, index) {
            final date = groupedNotifications.keys.elementAt(index);
            final notifications = groupedNotifications[date]!;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDateHeader(date),
                const SizedBox(height: 8.0),
                ...notifications.map((notification) => _buildNotificationItem(notification)),
                const SizedBox(height: 16.0),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    
    String dateText;
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      dateText = 'اليوم';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      dateText = 'أمس';
    } else {
      dateText = DateFormat('dd MMMM yyyy', 'ar').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        dateText,
        style: Get.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Get.theme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification) {
    final isUnread = !notification.read;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: isUnread
            ? BorderSide(
                color: Get.theme.primaryColor.withOpacity(0.5),
                width: 1.0,
              )
            : BorderSide.none,
      ),
      elevation: isUnread ? 2.0 : 1.0,
      child: InkWell(
        onTap: () {
          if (isUnread) {
            _controller.markAsRead(notification.id, isUserSpecific: true);
          }
          // Handle notification tap (e.g., navigate to specific screen)
          _handleNotificationTap(notification);
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isUnread)
                    Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                notification.body,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                DateFormat('h:mm a', 'ar').format(notification.timestamp),
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(AppNotification notification) {
    // Handle different notification types based on data
    // For example:
    // if (notification.data['type'] == 'order') {
    //   Get.toNamed(MyRoutes.orderDetails, arguments: notification.data['orderId']);
    // }
  }
}
