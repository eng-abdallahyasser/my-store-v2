import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/model/address.dart';
import 'package:store_app_v2/data/model/my_order.dart';
import 'package:store_app_v2/data/model/product.dart';

class OrderDetailsScreen extends StatefulWidget {
  final MyOrder order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final Map<String, Product> _products = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      for (var item in widget.order.items) {
        if (_products.containsKey(item.productId)) continue;
        
        final doc = await FirebaseFirestore.instance
            .collection('products')
            .doc(item.productId)
            .get();
            
        if (doc.exists) {
          final data = doc.data()!;
          data['id'] = doc.id;
          final product = Product(
            id: data['id'] ?? '',
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            category: data['category'] ?? '',
            imagesUrl: List<String>.from(data['images'] ?? []),
            colors: (data['colors'] as List<dynamic>?)?.map((c) => _colorFromString(c.toString())).toList() ?? [],
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            oldPrice: (data['oldPrice'] as num?)?.toDouble() ?? 0.0,
            isPopular: data['isPopular'] ?? false,
            rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
            favouritecount: data['favouritecount'] ?? 0,
            quantity: 1,
          );
          setState(() {
            _products[item.productId] = product;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading products: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Color _colorFromString(String colorString) {
    try {
      final buffer = StringBuffer();
      if (colorString.length == 6 || colorString.length == 7) {
        buffer.write('ff'); // Add alpha value
      }
      buffer.write(colorString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.order.orderNumber}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Status
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Order Status',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.order.status.toLowerCase() == 'pending'
                                      ? Colors.blue
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.order.status.toLowerCase() == 'pending' ? 'Pending' : 'Confirmed',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Order Date',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.order.createdAt.toDate().day}/${widget.order.createdAt.toDate().month}/${widget.order.createdAt.toDate().year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Shipping Information

                  Container(
                    width: double.infinity,
                    child: Card(
                      
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Shipping Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${widget.order.customerName}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${widget.order.customerEmail}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${ widget.order.customerPhone}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Shipping Address',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text('${Address.fromCompactAddress(widget.order.shippingAddress).getFormattedAddress()}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order Items
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Items',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...widget.order.items.map((item) {
                            final product = _products[item.productId];
                            return ListTile(
                              leading: product?.imagesUrl.isNotEmpty == true
                                  ? Image.network(
                                      product!.imagesUrl.first,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.shopping_bag, size: 40),
                              title: Text(product?.title ?? 'Product ${item.productId}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Quantity: ${item.quantity}'),
                                  if (item.choosedVariant.isNotEmpty)
                                    Text('Variants: ${item.choosedVariant.map((v) => v.name).join(', ')}'),
                                ],
                              ),
                              trailing: Text(
                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order Summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal'),
                              Text('\$${widget.order.total.toStringAsFixed(2)}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping'),
                              Text('\$${0.00}'), // Shipping fee not available in MyOrder model
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${widget.order.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
    );
  }
}
