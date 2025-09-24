import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/services/notification_service.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final NotificationController controller = Get.put(NotificationController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          IconButton(
            tooltip: 'تحديد كمقروء',
            onPressed: controller.markAllRead,
            icon: const Icon(Icons.done_all),
          ),
          IconButton(
            tooltip: 'مسح الكل',
            onPressed: controller.clearAll,
            icon: const Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text('لا توجد إشعارات حالياً'),
          );
        }
        return ListView.separated(
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final n = controller.notifications[index];
            return ListTile(
              leading: Icon(
                n.read ? Icons.notifications_none : Icons.notifications_active,
                color: n.read ? Colors.grey : Theme.of(context).colorScheme.primary,
              ),
              title: Text(n.title),
              subtitle: Text(n.body),
              trailing: Text(
                _formatTime(n.timestamp),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {
                // In future, navigate based on n.data
                // For now mark as read
                controller.notifications[index] = n.copyWith(read: true);
                controller.notifications.refresh();
              },
            );
          },
        );
      }),
    );
  }

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return '${diff.inMinutes} د';
    if (diff.inHours < 24) return '${diff.inHours} س';
    return '${t.year}/${t.month.toString().padLeft(2, '0')}/${t.day.toString().padLeft(2, '0')}';
  }
}
