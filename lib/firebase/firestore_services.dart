import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app_v2/data/model/address.dart';
import 'package:store_app_v2/data/model/product.dart';
import 'package:store_app_v2/data/model/order.dart';

class FirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentReference> addProduct(
      Product product, List<Uint8List> images) async {
    // Add the product to Firestore
    DocumentReference docRef =
        await _firestore.collection("products").add(product.toJson());

    // Generate URLs for images
    List<String> urls = [];
    for (int index = 0; index < images.length; index++) {
      urls.add("${docRef.id}/image$index.jpg");
    }

    // Update the Firestore document with the document ID and image URLs
    await docRef.update({"id": docRef.id, "images": urls});
    return docRef;
  }

  Future<int> incrementFavoriteCountById(
      String productId, String userId) async {
    DocumentReference docRef = _firestore.collection("products").doc(productId);
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    int currentFavoriteCount = 0;
    // Use a transaction to ensure atomic updates
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot docSnapshot = await transaction.get(docRef);
      currentFavoriteCount =
          (docSnapshot.data() as Map<String, dynamic>)['favouritecount'] ?? 0;
      if (docSnapshot.exists) {
        transaction
            .update(docRef, {"favouritecount": currentFavoriteCount + 1});
      }

      await userRef.set(
          {
            'favorites': FieldValue.arrayUnion([productId])
          },
          SetOptions(merge:true)); // Merge ensures existing fields are not overwritten
    });

    return currentFavoriteCount + 1;
  }

  Future<int> decrementFavoriteCountById(
      String productId, String userId) async {
    DocumentReference docRef = _firestore.collection("products").doc(productId);
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    int newFavoriteCount = 0;
    // Use a transaction to ensure atomic updates
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot docSnapshot = await transaction.get(docRef);

      if (docSnapshot.exists) {
        int currentFavoriteCount =
            (docSnapshot.data() as Map<String, dynamic>)['favouritecount'] ?? 0;
        // Ensure the favorite count does not go below 0
        newFavoriteCount =
            currentFavoriteCount > 0 ? currentFavoriteCount - 1 : 0;
        transaction.update(docRef, {"favouritecount": newFavoriteCount});
      }

      await userRef.update({
        'favorites': FieldValue.arrayRemove([productId])
      });
    });
    return newFavoriteCount;
  }

  Future<void> addAdminToken(String token) async {
    // Query to check if the token already exists
    QuerySnapshot existingTokens = await _firestore
        .collection("admins")
        .where("token", isEqualTo: token)
        .get();

    // If the token already exists, return early to prevent duplicate entry
    if (existingTokens.docs.isNotEmpty) {
      return;
    }
    // Add the new admin token to the collection
    DocumentReference docRef = await _firestore.collection("admins").add({
      "name": _auth.currentUser!.displayName,
      "token": token,
    });

    // Update the document with its own ID
    await docRef.update({"id": docRef.id});
  }

  Future<List<String>> getFavorites(String userID) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    if (userSnapshot.exists) {
      List<dynamic> favorites = userSnapshot.get('favorites') ?? [];
      return List<String>.from(favorites);
    }
    return [];
  }

  Future<List<String>> getAdminTokens() async {
    // Query to get all documents in the "admins" collection
    QuerySnapshot querySnapshot = await _firestore.collection("admins").get();

    // Extract tokens from the documents
    List<String> tokens = querySnapshot.docs.map((doc) {
      return doc['token'] as String;
    }).toList();

    // Return the list of tokens
    return tokens;
  }

  Future<void> addOrder(OrderForDelivary order) async {
    try {
      // Create a reference to the counter document
      DocumentReference counterRef =
          _firestore.collection("counters").doc("orderCounter");

      // Run a transaction to ensure atomicity
      await _firestore.runTransaction((transaction) async {
        // Get the current counter value
        DocumentSnapshot counterSnapshot = await transaction.get(counterRef);

        // Check if the document exists, if not create it with an initial currentNumber of 0
        int currentNumber = 0;
        if (!counterSnapshot.exists) {
          transaction.set(counterRef, {'currentNumber': currentNumber});
        } else {
          currentNumber = (counterSnapshot.data()
                  as Map<String, dynamic>)['currentNumber'] ??
              0;
        }

        // Increment the counter
        int newNumber = currentNumber + 1;

        // Update the order with the new number
        order.number = newNumber;

        // Create a new document reference for the order
        DocumentReference docRef = _firestore.collection("orders").doc();

        // Add the order to Firestore within the transaction
        transaction.set(docRef, order.toJson());

        // Update the orderID field in the newly created order document
        transaction.update(docRef, {"orderID": docRef.id});

        // Update the counter value in Firestore
        transaction.update(counterRef, {'currentNumber': newNumber});
      });
    } catch (error) {
      log("Failed to add order: $error");
    }
  }

  Future<Product> getProductById(String id) async {
    final DocumentSnapshot doc =
        await _firestore.collection("products").doc(id).get();

    if (!doc.exists) {
      throw Exception("Product not found");
    }

    return Product.fromFirestore(doc);
  }

  Future<List<Product>> getAllProduct() async {
    final QuerySnapshot querySnapshot =
        await _firestore.collection('products').get();

    return querySnapshot.docs.map((doc) {
      return Product.fromFirestore(doc);
    }).toList();
  }

  Future<List<OrderForDelivary>> getAllOrders() async {
    final QuerySnapshot querySnapshot =
        await _firestore.collection("orders").get();

    return querySnapshot.docs.map((doc) {
      return OrderForDelivary.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      return querySnapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (e) {
      log('Error fetching products: $e');
      return [];
    }
  }

  Future<List<Product>> getPopularProducts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('isPopular', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (e) {
      log('Error fetching products: $e');
      return [];
    }
  }

  Future<void> addAddress(Address address) async {
    try {
      DocumentReference docRef =
          await _firestore.collection("addresses").add(address.toMap());

      // Get generated Firestore document ID
      String addressId = docRef.id;

      // Update Firestore document with the addressId
      await _firestore
          .collection("addresses")
          .doc(addressId)
          .update({"addressId": addressId});
    } catch (e) {
      log("Error adding address: $e");
    }
  }

  Future<List<Address>> getAddresses(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("addresses")
          .where("userId", isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => Address.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log("Error fetching addresses: $e");
      return [];
    }
  }
}
