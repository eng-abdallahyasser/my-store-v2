import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/data_source/base_repository.dart';
import 'package:store_app_v2/data/model/my_order.dart';
import 'package:store_app_v2/data/model/order.dart';

class OrderRepository extends BaseRepository {

  Future<List<MyOrder>> getOrders({List<String>? statusFilters}) async {
    Query query = firestore.collection('orders').orderBy('createdAt', descending: true);
    
    if (statusFilters != null && statusFilters.isNotEmpty) {
      query = query.where('status', whereIn: statusFilters);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => MyOrder.fromFirestore(doc)).toList();
  }

  Future<MyOrder> getOrderById(String orderId) async {
    final doc = await firestore.collection('orders').doc(orderId).get();
    return MyOrder.fromFirestore(doc);
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await firestore.collection('orders').doc(orderId).update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  Future<List<OrderForDelivary>> getAllOrders() async {
    try {
      final querySnapshot = await firestore.collection("orders").get();
      return querySnapshot.docs
          .map((doc) => OrderForDelivary.fromMap(doc.data()))
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> addOrder(MyOrder order) async {
    try {
      DocumentReference counterRef = firestore.collection("counters").doc("orderCounter");

      await firestore.runTransaction((transaction) async {
        DocumentSnapshot counterSnapshot = await transaction.get(counterRef);

        int currentNumber = 0;
        if (!counterSnapshot.exists) {
          transaction.set(counterRef, {'currentNumber': currentNumber});
        } else if (counterSnapshot.data() is Map<String, dynamic>) {
          currentNumber = (counterSnapshot.data() as Map<String, dynamic>)['currentNumber'] ?? 0;
        }

        int newNumber = currentNumber + 1;
        order.orderNumber = newNumber;

        DocumentReference docRef = firestore.collection("orders").doc();
        transaction.set(docRef, order.toMap());
        transaction.update(docRef, {"orderID": docRef.id});
        transaction.update(counterRef, {'currentNumber': newNumber});
      });
    } catch (error) {
      log("Failed to add order: $error");
      rethrow;
    }
  }

  Future<void> sendNotification(String orderId) async {
    // Implement your notification logic here
    // Could use Firebase Cloud Messaging
  }
}