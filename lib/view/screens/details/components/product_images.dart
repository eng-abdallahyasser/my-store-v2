import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:store_app_v2/controller/detailes_screen_controller.dart';
import 'package:store_app_v2/core/constants.dart';

class ProductImages extends StatelessWidget {
  final DetailesScreenController controller;

  const ProductImages({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailesScreenController>(
      builder: (controller) {
        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              // width: 238,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  controller.product.imagesUrl[controller.selectedImage],
                  // controller.product.imagesUrl[0],
                  fit: BoxFit.cover,
                  loadingBuilder: (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                  ) {
                    return Center(child: Icon(Icons.broken_image));
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                  controller.product.imagesUrl.length,
                  (index) =>
                      SmallProductImage(controller: controller, index: index),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class SmallProductImage extends StatelessWidget {
  const SmallProductImage({
    super.key,
    required this.controller,
    required this.index,
  });

  final DetailesScreenController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.selectImageIndex(index);
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(2),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: MyColors.elsie.withOpacity(
              controller.selectedImage == index ? 1 : 0,
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            controller.product.imagesUrl[index],
            fit: BoxFit.cover,
            loadingBuilder: (
              BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              return Center(child: Icon(Icons.broken_image));
            },
          ),
        ),
      ),
    );
  }
}
