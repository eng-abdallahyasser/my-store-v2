import 'package:get/get.dart';
import 'package:store_app_v2/controller/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
      fenix: true,
    );
  }
}
