import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/controller/order_controller.dart';
import 'package:store_app_v2/controller/auth_controller.dart';
import 'package:store_app_v2/view/screens/orders/order_card.dart';
import 'package:store_app_v2/view/screens/orders/order_details_screen.dart';

class OrdersListScreen extends StatelessWidget {
  final OrderController _orderController = Get.put(OrderController());
  final AuthController _authController = Get.put(AuthController());

  OrdersListScreen({super.key});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // _showFilterDialog();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Get current user ID
        final currentUserId = _authController.user?.uid ?? '';

        // Filter orders by current user and status
        final userOrders =
            _orderController.orders.where((order) {
              return order.userId == currentUserId;
            }).toList();

        if (userOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No orders found',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text('Your orders will appear here'),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _orderController.loadOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: userOrders.length,
            itemBuilder: (context, index) {
              final order = userOrders[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => OrderDetailsScreen(order: order));
                },
                child: OrderCard(order: order),
              );
            },
          ),
        );
      }),
    );
  }

  // void _showFilterDialog() {
  //   Get.dialog(
  //     AlertDialog(
  //       title: const Text('Filter Orders'),
  //       content: Obx(() => Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           ..._controller.statusList.map((status) => CheckboxListTile(
  //             title: Text(status),
  //             value: _controller.selectedStatus.contains(status),
  //             onChanged: (value) => _controller.toggleStatusFilter(status),
  //           )).toList(),
  //         ],
  //       )),
  //       actions: [
  //         TextButton(
  //           onPressed: Get.back,
  //           child: const Text('Close'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
