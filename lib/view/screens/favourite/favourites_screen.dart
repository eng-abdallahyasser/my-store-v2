import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/view/global widget/product_card.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoritesController>(
      builder: (controller) {
        return SafeArea(
          child: Column(
            children: [
              Text(
                "Favorites",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: controller.favouriteProducts.isEmpty
                      ? const Center(
                          child: Text("No favorites yet"),
                        )
                      : GridView.builder(
                          itemCount: controller.favouriteProducts.length,
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 0.7,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) =>
                              FutureBuilder(
                                future: Repo.product.getProductById(controller.favouriteProducts[index]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError || snapshot.data == null) {
                                    return const Center(
                                      child: Text("Error: Item not found"),
                                    );
                                  }
                                  return ProductCard(
                                    product: snapshot.data!,
                                  );
                                }
                              ),
                        ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class FavoritesController extends GetxController {
  static FavoritesController get instance => Get.find<FavoritesController>();

  List<String> favouriteProducts = [];

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    favouriteProducts = Repo.favouriteProducts;
    update();
  }

  void refreshFavorites() {
    loadFavorites();
  }
}
