import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadImages(List<Uint8List> images, String id) async {
    // Upload each image to Firebase Storage
    for (int index = 0; index < images.length; index++) {
      final imageRef = _storage.ref().child("$id/image$index.jpg");
      await imageRef.putData(images[index]);
    }
  }

  Future<Uint8List?> getProductImageUrl(String url) async {
    final Uint8List? image = await _storage.ref().child(url).getData();
    try {
      return image;
    } catch (e) {
      log('Failed to get profile picture for uid $url: $e');
      return null;
    }
  }

  Future<Uint8List?> getProductImageByNumber(
      String productId, int number) async {
    try {
      return await _storage
          .ref()
          .child("$productId/image$number.jpg")
          .getData();
    } catch (e) {
      log('Failed to get profile picture for uid $productId: $e');
      return null;
    }
  }
}
