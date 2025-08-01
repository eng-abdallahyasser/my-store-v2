import 'dart:typed_data';
import 'package:store_app_v2/data/data_source/address_repository.dart';
import 'package:store_app_v2/data/data_source/auth_repository.dart';
import 'package:store_app_v2/data/data_source/favorites_repository.dart';
import 'package:store_app_v2/data/data_source/order_repository.dart';
import 'package:store_app_v2/data/data_source/product_repository.dart';
import 'package:store_app_v2/data/model/product.dart';
import 'package:store_app_v2/data/model/cart_item.dart';
import 'package:store_app_v2/firebase/storage_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repo {
  static final ProductRepository product = ProductRepository();
  static final OrderRepository order = OrderRepository();
  static final AuthRepository auth = AuthRepository();
  static final AddressRepository address = AddressRepository();
  static final FavoritesRepository favorites = FavoritesRepository();

  static final StorageServices _storage = StorageServices();

  static var prefs;
  static bool onboardingShown = false;
  static List<String> favouriteProducts = [];

  Map<String, dynamic>? delivaryData = {};
  static List<Product> fetchedProducts = [];
  static bool isProductsFetched = false;
  static List<CartItem> demoCarts = [];
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
}
