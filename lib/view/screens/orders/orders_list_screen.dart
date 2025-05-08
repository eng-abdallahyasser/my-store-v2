import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/controller/order_controller.dart';
import 'package:store_app_v2/view/screens/orders/order_card.dart';

class OrdersListScreen extends StatelessWidget {
  final OrderController _controller = Get.put(OrderController());
  OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: (){
              // _showFilterDialog();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: _controller.loadOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _controller.orders.length,
            itemBuilder: (context, index) {
              final order = _controller.orders[index];
              return OrderCard(
                order: order,
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