import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/data_source/base_repository.dart';
import 'package:store_app_v2/data/model/address.dart';

class AddressRepository extends BaseRepository {
  Future<void> addAddress(Address address) async {
    try {
      DocumentReference docRef = await firestore.collection("addresses").add(address.toMap());
      await firestore.collection("addresses").doc(docRef.id).update({
        "addressId": docRef.id,
      });
    } catch (e) {
      log("Error adding address: $e");
      rethrow;
    }
  }

  Future<List<Address>> getAddresses(String userId) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection("addresses")
          .where("userId", isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => Address.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log("Error fetching addresses: $e");
      rethrow;
    }
  }
}