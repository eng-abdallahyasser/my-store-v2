import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/model/address.dart';
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
  static List<Map<String, dynamic>> testProducts = [
    {
      "category": "Sushi Rolls",
      "colors": ["#ff44336", "#ffff9800"],
      "description":
          "Delicious salmon roll with creamy avocado and a touch of wasabi. 🍣",
      "favouritecount": 15,
      "images": ["https://example.com/salmon_roll.jpg"],
      "isFavourite": false,
      "isPopular": true,
      "oldPrice": 18,
      "price": 15,
      "quantity": 50,
      "rating": 4.7,
      "title": "Salmon Roll"
    },
    {
      "category": "Sushi Rolls",
      "colors": ["#ffcc00", "#ff5733"],
      "description":
          "A classic California roll with crab, avocado, and cucumber. 🌊",
      "favouritecount": 10,
      "images": ["https://example.com/california_roll.jpg"],
      "isFavourite": false,
      "isPopular": true,
      "oldPrice": 14,
      "price": 12,
      "quantity": 60,
      "rating": 4.6,
      "title": "California Roll"
    },
    {
      "category": "Sushi Rolls",
      "colors": ["#ffb74d", "#8d6e63"],
      "description":
          "Spicy tuna roll with sriracha mayo and crunchy tempura flakes. 🌶️",
      "favouritecount": 12,
      "images": ["https://example.com/spicy_tuna_roll.jpg"],
      "isFavourite": false,
      "isPopular": true,
      "oldPrice": 16,
      "price": 14,
      "quantity": 40,
      "rating": 4.8,
      "title": "Spicy Tuna Roll"
    },
    {
      "category": "Nigiri",
      "colors": ["#e53935", "#ffca28"],
      "description": "Freshly sliced salmon over seasoned sushi rice. 🍣",
      "favouritecount": 20,
      "images": ["https://example.com/salmon_nigiri.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 10,
      "price": 8,
      "quantity": 30,
      "rating": 4.9,
      "title": "Salmon Nigiri"
    },
    {
      "category": "Nigiri",
      "colors": ["#b71c1c", "#ffb300"],
      "description": "Fresh tuna slice over hand-pressed sushi rice. 🐟",
      "favouritecount": 18,
      "images": ["https://example.com/tuna_nigiri.jpg"],
      "isFavourite": false,
      "isPopular": true,
      "oldPrice": 11,
      "price": 9,
      "quantity": 35,
      "rating": 4.8,
      "title": "Tuna Nigiri"
    },
    {
      "category": "Nigiri",
      "colors": ["#ff6f00", "#ffecb3"],
      "description": "Fresh shrimp nigiri served with a hint of lemon. 🍤",
      "favouritecount": 14,
      "images": ["https://example.com/shrimp_nigiri.jpg"],
      "isFavourite": false,
      "isPopular": false,
      "oldPrice": 9,
      "price": 7,
      "quantity": 20,
      "rating": 4.5,
      "title": "Shrimp Nigiri"
    },
    {
      "category": "Sushi Rolls",
      "colors": ["#ff7043", "#fbc02d"],
      "description": "Dragon Roll with eel, avocado, and cucumber. 🐉",
      "favouritecount": 18,
      "images": ["https://example.com/dragon_roll.jpg"],
      "isFavourite": false,
      "isPopular": true,
      "oldPrice": 20,
      "price": 18,
      "quantity": 40,
      "rating": 4.8,
      "title": "Dragon Roll"
    },
    {
      "category": "Sushi Rolls",
      "colors": ["#9c27b0", "#ce93d8"],
      "description": "Rainbow Roll with assorted fresh fish and avocado. 🌈",
      "favouritecount": 22,
      "images": ["https://example.com/rainbow_roll.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 21,
      "price": 19,
      "quantity": 45,
      "rating": 4.9,
      "title": "Rainbow Roll"
    },
    {
      "category": "Sushi Rolls",
      "colors": ["#ff5252", "#ff8a80"],
      "description":
          "Philadelphia Roll with smoked salmon and cream cheese. 🏙️",
      "favouritecount": 16,
      "images": ["https://example.com/philadelphia_roll.jpg"],
      "isFavourite": false,
      "isPopular": false,
      "oldPrice": 17,
      "price": 15,
      "quantity": 35,
      "rating": 4.6,
      "title": "Philadelphia Roll"
    },
    {
      "category": "Nigiri",
      "colors": ["#ff9800", "#ffcc80"],
      "description": "Eel Nigiri with sweet teriyaki glaze. 🍣",
      "favouritecount": 14,
      "images": ["https://example.com/eel_nigiri.jpg"],
      "isFavourite": false,
      "isPopular": true,
      "oldPrice": 12,
      "price": 10,
      "quantity": 30,
      "rating": 4.7,
      "title": "Eel Nigiri"
    },
    {
      "category": "Nigiri",
      "colors": ["#ff1744", "#d50000"],
      "description": "Yellowtail Nigiri with a hint of lemon. 🍋",
      "favouritecount": 20,
      "images": ["https://example.com/yellowtail_nigiri.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 13,
      "price": 11,
      "quantity": 40,
      "rating": 4.9,
      "title": "Yellowtail Nigiri"
    },
    {
      "category": "Nigiri",
      "colors": ["#009688", "#80cbc4"],
      "description": "Egg Omelette Nigiri with a touch of soy. 🍳",
      "favouritecount": 12,
      "images": ["https://example.com/egg_nigiri.jpg"],
      "isFavourite": false,
      "isPopular": false,
      "oldPrice": 9,
      "price": 7,
      "quantity": 25,
      "rating": 4.5,
      "title": "Tamago Nigiri"
    },
    {
      "category": "Sashimi",
      "colors": ["#d32f2f", "#f44336"],
      "description": "Fresh scallop sashimi with citrus sauce. 🌊",
      "favouritecount": 17,
      "images": ["https://example.com/scallop_sashimi.jpg"],
      "isFavourite": false,
      "isPopular": false,
      "oldPrice": 22,
      "price": 20,
      "quantity": 15,
      "rating": 4.7,
      "title": "Scallop Sashimi"
    },
    {
      "category": "Sashimi",
      "colors": ["#ffb300", "#ffca28"],
      "description": "Red Snapper Sashimi, delicate and flavorful. 🐠",
      "favouritecount": 19,
      "images": ["https://example.com/red_snapper_sashimi.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 23,
      "price": 21,
      "quantity": 20,
      "rating": 4.9,
      "title": "Red Snapper Sashimi"
    },
    {
      "category": "Sashimi",
      "colors": ["#4a148c", "#7e57c2"],
      "description": "Mackerel Sashimi with a bold taste. 🐟",
      "favouritecount": 15,
      "images": ["https://example.com/mackerel_sashimi.jpg"],
      "isFavourite": false,
      "isPopular": true,
      "oldPrice": 19,
      "price": 17,
      "quantity": 18,
      "rating": 4.6,
      "title": "Mackerel Sashimi"
    },
    {
      "category": "Bento Boxes",
      "colors": ["#ff6d00", "#ffab40"],
      "description": "Beef Teriyaki Bento with miso soup and rice. 🍱",
      "favouritecount": 25,
      "images": ["/Pfw27PB4onVf9nB5aBPM/image0.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 25,
      "price": 23,
      "quantity": 30,
      "rating": 4.8,
      "title": "Beef Teriyaki Bento"
    },
    {
      "category": "Side Dishes",
      "colors": ["#00bcd4", "#4dd0e1"],
      "description": "Seaweed Salad with sesame dressing. 🥗",
      "favouritecount": 14,
      "images": ["https://example.com/seaweed_salad.jpg"],
      "isFavourite": false,
      "isPopular": true,
      "oldPrice": 7,
      "price": 6,
      "quantity": 40,
      "rating": 4.5,
      "title": "Seaweed Salad"
    },
    {
      "category": "Side Dishes",
      "colors": ["#ef5350", "#e57373"],
      "description": "Gyoza dumplings with soy dipping sauce. 🥟",
      "favouritecount": 21,
      "images": ["https://example.com/gyoza.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 9,
      "price": 8,
      "quantity": 50,
      "rating": 4.7,
      "title": "Gyoza Dumplings"
    },
    {
      "category": "Beverages",
      "colors": ["#8e24aa", "#ab47bc"],
      "description": "Japanese Plum Wine, sweet and refreshing. 🍷",
      "favouritecount": 30,
      "images": ["https://example.com/plum_wine.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 12,
      "price": 10,
      "quantity": 60,
      "rating": 4.9,
      "title": "Plum Wine"
    },
    {
      "category": "Beverages",
      "colors": ["#fdd835", "#ffeb3b"],
      "description": "Yuzu Citrus Soda, tangy and sweet. 🍋",
      "favouritecount": 28,
      "images": ["https://example.com/yuzu_soda.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 6,
      "price": 5,
      "quantity": 70,
      "rating": 4.8,
      "title": "Yuzu Soda"
    },
    {
      "category": "Sashimi",
      "colors": ["#ff7043", "#bf360c"],
      "description":
          "Thinly sliced fresh salmon served with soy sauce and wasabi. 🐠",
      "favouritecount": 22,
      "images": ["https://example.com/salmon_sashimi.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 20,
      "price": 18,
      "quantity": 25,
      "rating": 4.9,
      "title": "Salmon Sashimi"
    },
    {
      "category": "Sashimi",
      "colors": ["#d84315", "#ff9800"],
      "description": "Thinly sliced tuna, rich in flavor and texture. 🐟",
      "favouritecount": 19,
      "images": ["https://example.com/tuna_sashimi.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 21,
      "price": 19,
      "quantity": 22,
      "rating": 4.9,
      "title": "Tuna Sashimi"
    },
    {
      "category": "Sashimi",
      "colors": ["#ff6d00", "#ffccbc"],
      "description": "Tender octopus sashimi with a citrus soy glaze. 🐙",
      "favouritecount": 11,
      "images": ["https://example.com/octopus_sashimi.jpg"],
      "isFavourite": false,
      "isPopular": false,
      "oldPrice": 18,
      "price": 16,
      "quantity": 15,
      "rating": 4.4,
      "title": "Octopus Sashimi"
    },
    {
      "category": "Bento Boxes",
      "colors": ["#9e9d24", "#ffb300"],
      "description":
          "Bento box with teriyaki chicken, sushi rolls, and steamed rice. 🍱",
      "favouritecount": 25,
      "images": ["https://example.com/teriyaki_bento.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 22,
      "price": 20,
      "quantity": 30,
      "rating": 4.8,
      "title": "Teriyaki Chicken Bento"
    },
    {
      "category": "Bento Boxes",
      "colors": ["#8bc34a", "#795548"],
      "description": "Grilled salmon bento box with vegetables and rice. 🍱",
      "favouritecount": 21,
      "images": ["https://example.com/salmon_bento.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 24,
      "price": 22,
      "quantity": 28,
      "rating": 4.9,
      "title": "Grilled Salmon Bento"
    },
    {
      "category": "Side Dishes",
      "colors": ["#f57c00", "#ffcc80"],
      "description": "Crispy tempura shrimp served with dipping sauce. 🍤",
      "favouritecount": 17,
      "images": ["https://example.com/tempura_shrimp.jpg"],
      "isFavourite": false,
      "isPopular": true,
      "oldPrice": 10,
      "price": 8,
      "quantity": 40,
      "rating": 4.7,
      "title": "Tempura Shrimp"
    },
    {
      "category": "Beverages",
      "colors": ["#4caf50", "#388e3c"],
      "description": "Traditional matcha green tea, hot or iced. 🍵",
      "favouritecount": 30,
      "images": ["https://example.com/matcha_tea.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 6,
      "price": 5,
      "quantity": 50,
      "rating": 4.9,
      "title": "Matcha Green Tea"
    },
    {
      "category": "Beverages",
      "colors": ["#03a9f4", "#0288d1"],
      "description": "Refreshing Japanese ramune soda with fruity flavors. 🥤",
      "favouritecount": 27,
      "images": ["https://example.com/ramune.jpg"],
      "isFavourite": true,
      "isPopular": true,
      "oldPrice": 5,
      "price": 4,
      "quantity": 60,
      "rating": 4.8,
      "title": "Ramune Soda"
    }
  ];

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

  static Future<void> addOrder(OrderForDelivary order) async {
    order.userID = _auth.getCurrentUser()!.uid;
    await _firestore.addOrder(order);
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
}
