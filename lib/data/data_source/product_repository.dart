import 'dart:developer';
import 'dart:typed_data';
import 'package:store_app_v2/data/data_source/base_repository.dart';
import 'package:store_app_v2/data/model/product.dart';

class ProductRepository extends BaseRepository {
  List<Product> fetchedProducts = [];
  bool isProductsFetched = false;

  Future<void> fetchAllProducts() async {
    fetchedProducts = await _getAllProducts();
    isProductsFetched = true;
  }

  Future<Product> getProductById(String id) async {
    if (isProductsFetched) {
      return fetchedProducts.firstWhere((element) => element.id == id);
    }
    return _getProductById(id);
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    if (isProductsFetched) {
      return fetchedProducts
          .where((element) => element.category == category)
          .toList();
    }
    return _getProductsByCategory(category);
  }

  Future<List<Product>> getPopularProducts() async {
    if (isProductsFetched) {
      return fetchedProducts
          .where((element) => element.isPopular == true)
          .toList();
    }
    return _getPopularProducts();
  }

  Future<void> addProduct(Product product, List<Uint8List> images) async {
    try {
      final docRef = await firestore.collection("products").add(product.toJson());
      
      List<String> urls = [];
      for (int index = 0; index < images.length; index++) {
        urls.add("${docRef.id}/image$index.jpg");
      }

      await docRef.update({"id": docRef.id, "images": urls});
      
      for (int index = 0; index < images.length; index++) {
        final imageRef = storage.ref().child("${docRef.id}/image$index.jpg");
        await imageRef.putData(images[index]);
      }
    } catch (error) {
      log("Failed to add product: $error");
      rethrow;
    }
  }

  // Private methods
  Future<List<Product>> _getAllProducts() async {
    final querySnapshot = await firestore.collection('products').get();
    return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  Future<Product> _getProductById(String id) async {
    final doc = await firestore.collection("products").doc(id).get();
    if (!doc.exists) throw Exception("Product not found");
    return Product.fromFirestore(doc);
  }

  Future<List<Product>> _getProductsByCategory(String category) async {
    try {
      final querySnapshot = await firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      log('Error fetching products: $e');
      rethrow;
    }
  }

  Future<List<Product>> _getPopularProducts() async {
    try {
      final querySnapshot = await firestore
          .collection('products')
          .where('isPopular', isEqualTo: true)
          .get();
      return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      log('Error fetching products: $e');
      rethrow;
    }
  }
}