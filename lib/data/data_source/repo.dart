import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/model/address.dart';
import 'package:store_app_v2/data/model/my_order.dart';
import 'package:store_app_v2/data/model/product.dart';
import 'package:store_app_v2/data/model/cart_item.dart';
import 'package:store_app_v2/data/model/order.dart';
import 'package:store_app_v2/firebase/auth.dart';
import 'package:store_app_v2/firebase/firestore_services.dart';
import 'package:store_app_v2/firebase/storage_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repo {
  static final FirestoreServices _firestore = FirestoreServices();
  static final StorageServices _storage = StorageServices();
  static final Auth _auth = Auth();
  static var prefs;
  static bool onboardingShown = false;
  Map<String, dynamic>? delivaryData = {};
  static List<String> favouriteProducts = [];

  static List<Product> fetchedProducts = [];
  static bool isProductsFetched = false;
  static List<CartItem> demoCarts = [];
  static List<Map<String, dynamic>> testProducts = [];

  static Future<void> init() async {
    favouriteProducts = await getFavorites();
    fetchAllProduct();
    prefs = await SharedPreferences.getInstance();
    onboardingShown = prefs.getBool('onboardingShown') ?? false;
  }

  static fetchAllProduct() async {
    fetchedProducts = await _firestore.getAllProduct();
    isProductsFetched = true;
  }

  static Future<List<OrderForDelivary>> getAllOrders() async {
    try {
      return _firestore.getAllOrders();
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  static Future<List<String>> getFavorites() async {
    if(_auth.getCurrentUser() == null) return [];
    return _firestore.getFavorites(_auth.getCurrentUser()!.uid);
  }

  static Future<Product> getProductById(String id) async {
    if (isProductsFetched) {
      return fetchedProducts.firstWhere((element) => element.id == id);
    }
    return _firestore.getProductById(id);
  }

  static Future<List<Product>> getProductsByCategory(String category) async {
    if (isProductsFetched) {
      return fetchedProducts
          .where((element) => element.category == category)
          .toList();
    }
    return _firestore.getProductsByCategory(category);
  }

  static Future<List<Product>> getPopularProducts() async {
    if (isProductsFetched) {
      return fetchedProducts
          .where((element) => element.isPopular == true)
          .toList();
    }
    return _firestore.getPopularProducts();
  }

  static Future<int> removeFromFavorites(String id) async {
    return _firestore.decrementFavoriteCountById(
        id, _auth.getCurrentUser()!.uid);
  }

  static Future<void> addToFavorites(String productId) async {
    await _firestore.incrementFavoriteCountById(
        productId, _auth.getCurrentUser()!.uid);
  }

  static Future<Uint8List?> getProductImageNumber(
      String productId, int number) async {
    return await _storage.getProductImageByNumber(productId, number);
  }

  static Future<Uint8List?> getProductImageUrl(String url) async {
    return await _storage.getProductImageUrl(url);
  }

  static Future<void> addItem(Product product, List<Uint8List> images) async {
    try {
      // Add the product to Firestore
      DocumentReference docRef = await _firestore.addProduct(product, images);
      // Upload each image to Firebase Storage
      _storage.uploadImages(images, docRef.id);
    } catch (error) {
      log("Failed to add product: $error");
    }
  }

  static Future<void> addOrder(MyOrder order) async {
    String userId = _auth.getCurrentUser()!.uid;
    String userEmail = _auth.getCurrentUser()!.email ?? 'not found';
    String userName = _auth.getCurrentUser()!.displayName ?? "Unknown User";

    await _firestore.addOrder(order.copyWith(
        userId: userId,
        customerEmail: userEmail,
        customerName: userName,
      ));
  }

  static Future<void> addAddress(Address address) async {
    address.userId = _auth.getCurrentUser()!.uid;
    await _firestore.addAddress(address);
  }

  static Future<List<Address>> getAddresses() {
    if(_auth.getCurrentUser() == null) return Future.value([]);
    return _firestore.getAddresses(_auth.getCurrentUser()!.uid);
  }

  static saveAdminToken() {}

  static Product getFetchedProductById(String productId) {
    if (isProductsFetched) {
      return fetchedProducts.firstWhere((element) => element.id == productId);
    }
    // If not fetched, return a default product or handle the error as needed
    throw Exception("Product not found in fetched products.");
    }
}
