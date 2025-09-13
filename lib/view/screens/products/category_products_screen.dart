import 'package:flutter/material.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/data/model/product.dart';
import 'package:store_app_v2/view/global%20widget/product_card.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryTitle;

  const CategoryProductsScreen({super.key, required this.categoryTitle});

  Future<List<Product>> _loadProducts() {
    if (categoryTitle == "Popular Products") {
      return Repo.product.getPopularProducts();
    }
    return Repo.product.getProductsByCategory(categoryTitle);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: FutureBuilder<List<Product>>(
        future: _loadProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load products'));
          }
          final products = snapshot.data ?? const <Product>[];
          if (products.isEmpty) {
            return Center(
              child: Text(
                'No products found',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              const horizontalPadding = 16.0;
              const gridSpacing = 12.0;
              // 2 columns grid
              final availableWidth = constraints.maxWidth - (horizontalPadding * 2) - gridSpacing;
              final itemWidth = availableWidth / 2;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: gridSpacing,
                    crossAxisSpacing: gridSpacing,
                    childAspectRatio: 0.70,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      width: itemWidth,
                      product: product,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
