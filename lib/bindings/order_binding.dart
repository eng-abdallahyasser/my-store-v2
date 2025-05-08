
import 'package:get/get.dart';
import 'package:store_app_v2/controller/order_controller.dart';
import 'package:store_app_v2/data/data_source/order_repository.dart';


class OrderBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderRepository>(() => OrderRepository());
    Get.lazyPut<OrderController>(() => OrderController());
  }
}