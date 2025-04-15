import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:store_app_v2/controller/detailes_screen_controller.dart';
import 'package:store_app_v2/core/constants.dart';

class ProductImages extends StatelessWidget {
  final DetailesScreenController controller;

  const ProductImages({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailesScreenController>(builder: (controller) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            // width: 238,
            child: controller.isCoverImageLoaded ||
                    controller.isImagesLoaded[controller.selectedImage]
                ? AspectRatio(
                    aspectRatio: 1,
                    child: Image.memory(
                        controller.images[controller.selectedImage]!,
                        fit: BoxFit.cover),
                  )
                : controller.product.coverImageUnit8List != null
                    ? AspectRatio(
                        aspectRatio: 1,
                        child: Image.memory(
                            controller.product.coverImageUnit8List!,
                            fit: BoxFit.cover),
                      )
                    : const SizedBox(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Loading Images...'),
                          ],
                        ),
                      ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                controller.product.imagesUrl.length,
                (index) => SmallProductImage(
                  controller: controller,
                  index: index,
                ),
              ),
            ],
          )
        ],
      );
    });
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
                color: MyColors.elsie
                    .withOpacity(controller.selectedImage == index ? 1 : 0)),
          ),
          child: controller.isCoverImageLoaded ||
                  controller.isImagesLoaded[controller.selectedImage]
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    controller.images[index]!,
                    fit: BoxFit.cover,
                  ))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset("assets/images/product_placeholder.jpg"))),
    );
  }
}
