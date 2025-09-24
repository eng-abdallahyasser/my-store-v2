// order_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/data/model/my_order.dart';
import 'package:store_app_v2/view/screens/orders/order_details_screen.dart';

class OrderCard extends StatelessWidget {
  final MyOrder order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.orderNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Chip(
                  backgroundColor: _getStatusColor(),
                  label: Text(
                    order.status.toLowerCase() == 'pending' ? 'Pending' : 'Confirmed',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items: ${order.items.length}'),
                Text('Total: \$${_calculateTotal()}'),
              ],
            ),
            const SizedBox(height: 8),
            Text('Order #${order.orderNumber}'),
            Text('Date: ${_formatDate(order.createdAt.toDate())}'),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text('VIEW DETAILS'),
                onPressed: () {
                  Get.to(() => OrderDetailsScreen(order: order));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    return order.status.toLowerCase() == 'pending' ? Colors.blue : Colors.green;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _calculateTotal() {
    return order.total.toStringAsFixed(2);
  }
}
