import 'package:flutter/material.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/data/model/product.dart';
import 'package:store_app_v2/view/global%20widget/product_card.dart';
import 'package:store_app_v2/view/global%20widget/section_title.dart';

class ProductList extends StatelessWidget {
  final String title;
  const ProductList({
    super.key,
    this.title = "not titled",
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: title == "Popular Products"
            ? Repo.getPopularProducts()
            : Repo.getProductsByCategory(title),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error..."),
            );
          }
          if (snapshot.hasData) {
            var products = snapshot.data as List<Product>;
            if (products.isEmpty) {
              return const SizedBox.shrink();
            }
            return ProductListWidget(title: title, products: products);
          }
          return const SizedBox.shrink();
        });
  }
}

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({
    super.key,
    required this.title,
    required this.products,
  });

  final String title;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: title,
            press: () {},
          ),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                products.length,
                (index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: ProductCard(
                        product: products[index],
                      ),
                    );
                },
              ),
            )),
        const Divider()
      ],
    );
  }
}
