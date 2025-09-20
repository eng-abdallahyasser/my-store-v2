import 'dart:async';
import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/data/data_source/order_repository.dart';
import 'package:store_app_v2/data/model/my_order.dart';


class OrderController extends GetxController {
  final OrderRepository _repository = Get.put(OrderRepository());
  final RxList<MyOrder> orders = <MyOrder>[].obs;
  final Rx<MyOrder?> selectedOrder = Rx<MyOrder?>(null);
  final RxList<String> selectedStatus = <String>[].obs;
  final RxBool isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late StreamSubscription<QuerySnapshot> _ordersSubscription;

  
  final List<String> statusList = [
    'Pending',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled'
  ];

  @override
  void onInit() {
    loadOrders();
    _startListening();
    super.onInit();
  }
  void _startListening() {
    _ordersSubscription = _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          orders.assignAll(
            snapshot.docs.map((doc) => MyOrder.fromFirestore(doc)).toList()
          );
        });
  }
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> loadOrders() async {
    try {
      isLoading(true);
      final response = await _repository.getOrders();
      orders.value = response;
    } catch (e) {
      log(e.toString());
      Get.snackbar('خطأ', 'فشل في تحميل الطلبات: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<MyOrder?> loadOrderDetails(String orderId) async {
    try {
      isLoading(true);
      final response = await _repository.getOrderById(orderId);
      selectedOrder.value = response;
      return response;
    } catch (e) {
      log(e.toString());
      Get.snackbar('خطأ', 'فشل في تحميل تفاصيل الطلب');
      return null;
    } finally {
      isLoading(false);
    }
  }

  void toggleStatusFilter(String status) {
    if (selectedStatus.contains(status)) {
      selectedStatus.remove(status);
    } else {
      selectedStatus.add(status);
    }
    loadOrders();
  }

  Future<void> sendOrderUpdateNotification(String orderId) async {
    try {
      isLoading(true);
      await _repository.sendNotification(orderId);
      Get.snackbar('نجاح', 'تم إرسال الإشعار إلى العميل');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إرسال الإشعار');
    } finally {
      isLoading(false);
    }
  }
}