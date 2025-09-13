import 'package:flutter/material.dart';
import 'package:store_app_v2/view/global%20widget/section_title.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/features/category/controllers/category_controller.dart';
import 'package:store_app_v2/view/screens/products/category_products_screen.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<CategoryController>(
      builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle(title: "Menus", press: () {}),
            ),
            SizedBox(
              height: 90,
              child:
                  controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.errorMessage.value != null
                      ? Center(child: Text(controller.errorMessage.value!))
                      : controller.categories.isEmpty
                      ? const Center(child: Text("No Menus available"))
                      : ListView.separated(
                        padding: const EdgeInsets.only(right: 20),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final item = controller.categories[index];
                          return CategoryCard(
                            image: item.image,
                            category: item.name,
                            numOfBrands: 0,
                            press: () {
                              Get.to(() => CategoryProductsScreen(categoryTitle: item.name));
                            },
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: controller.categories.length,
                      ),
            ),
          ],
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  });

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 242,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                _CategoryImage(image: image),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.black38,
                        Colors.black26,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // TextSpan(text: "$numOfBrands Brands")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryImage extends StatelessWidget {
  final String image;
  const _CategoryImage({required this.image});

  @override
  Widget build(BuildContext context) {
    if (image.startsWith('assets/')) {
      return Image.asset(
        image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return Image.network(
      image,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Colors.grey.shade200,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }
}
