import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/data_source/address_repository.dart';
import 'package:store_app_v2/data/data_source/auth_repository.dart';
import 'package:store_app_v2/data/data_source/favorites_repository.dart';
import 'package:store_app_v2/data/data_source/order_repository.dart';
import 'package:store_app_v2/data/data_source/product_repository.dart';
import 'package:store_app_v2/data/data_source/terms_repository.dart';
import 'package:store_app_v2/data/data_source/privacy_policy_repository.dart';
import 'package:store_app_v2/data/model/product.dart';
import 'package:store_app_v2/data/model/restaurant_status.dart';
import 'package:store_app_v2/firebase/storage_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repo {
  static final ProductRepository product = ProductRepository();
  static final OrderRepository order = OrderRepository();
  static final AuthRepository auth = AuthRepository();
  static final AddressRepository address = AddressRepository();
  static final FavoritesRepository favorites = FavoritesRepository();
  static final TermsRepository terms = TermsRepository();
  static final PrivacyPolicyRepository privacyPolicy = PrivacyPolicyRepository();
  static final StorageServices _storage = StorageServices();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  static var prefs;
  static bool onboardingShown = false;
  static List<String> favouriteProducts = [];

  Map<String, dynamic>? delivaryData = {};
  static List<Product> fetchedProducts = [];
  static bool isProductsFetched = false;
  
  static List<Map<String, dynamic>> testProducts = [];

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    onboardingShown = prefs.getBool('onboardingShown') ?? false;

    if (auth.getCurrentUser() != null) {
      favouriteProducts = await favorites.getFavorites(
        auth.getCurrentUser()!.uid,
      );
    }
    await product.fetchAllProducts();
  }
 
  static Future<Uint8List?> getProductImageUrl(String url) async {
    return await _storage.getProductImageUrl(url);
  }

  static Product getFetchedProductById(String productId) {
    if (isProductsFetched) {
      return fetchedProducts.firstWhere((element) => element.id == productId);
    }
    // If not fetched, return a default product or handle the error as needed
    throw Exception("Product not found in fetched products.");
  }

  Future<RestaurantStatus?> fetchRestaurantStatus() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('status')
          .doc('main_restaurant') // Replace with your restaurant ID
          .get();
      
      if (doc.exists) {
        return RestaurantStatus.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      } 
    } catch (e) {
      return RestaurantStatus(autoMode: false, id: '', name: '', isOpen: false, closedMessage: 'Error fetching data', openingHours: {});
    }
    return null; 
  }

  // Submit suggestion or complaint to Firestore
  static Future<void> submitFeedback({
    required String userId,
    required String type, // 'Suggestion' or 'Complaint'
    required String message,
  }) async {
    await _firestore.collection('feedback').add({
      'userId': userId,
      'type': type,
      'message': message,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
