import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/controller/navigation_bar_controller.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/data/model/option.dart';
import 'package:store_app_v2/data/model/product.dart';
import 'package:store_app_v2/data/model/cart_item.dart';
import 'package:store_app_v2/data/model/variant.dart';

class DetailesScreenController extends GetxController {
  int selectedColor = 0;
  Product product;
  int numberOfItems = 1;
  int selectedImage = 0;
  List<Uint8List?> images = [];
  List<bool> isImagesLoaded = [false, false, false, false, false];
  bool isCoverImageLoaded = false;
  int favouriteCount = 0;

  DetailesScreenController({required this.product, this.favouriteCount = 0});

  @override
  void onInit() {
    super.onInit();
    fetchImages();
  }

  void selectColorIndex(int selectedColorIndex) {
    selectedColor = selectedColorIndex;
    update();
  }

  void selectImageIndex(int selectedImageIndex) {
    selectedImage = selectedImageIndex;
    update();
  }

  void addOneItem() {
    numberOfItems++;
    update();
  }

  void removeOneItem() {
    if (numberOfItems > 1) {
      numberOfItems--;
      update();
    }
  }

  void onAddToFavouritesTap() {
    if (!Repo.favouriteProducts.contains(product.id)) {
      Repo.favouriteProducts.add(product.id);
      favouriteCount++;
      Repo.addToFavorites(product.id);
    } else {
      favouriteCount--;
      Repo.favouriteProducts.remove(product.id);
      Repo.removeFromFavorites(product.id);
    }
    update();
  }

  Future<void> fetchImages() async {
    // for (int index = 0; index < product.imagesUrl.length; index++) {
    //   try {
    //     images[index] = await Repo.getProductImageUrl(product.imagesUrl[index]);

    //     isImagesLoaded[index] = true;

    //     update();
    //     print("fetchImage $index done");
    //   } catch (e) {
    //     isImagesLoaded[index] = false;
    //     print("error ${e.toString()} ");
    //   }
    // }
    images = await Future.wait(
      product.imagesUrl.map((url) => Repo.getProductImageUrl(url)).toList(),
    );
    isCoverImageLoaded = true;
    update();
  }

  void addToCart() {
    bool validOptions = true;
    for (Option option in product.options) {
      if (option.choosedVariant.isEmpty ||
          (option.choosedVariant.length < option.min ||
              option.choosedVariant.length > option.max)) {
        validOptions = false;
        break;
      }
    }
    if (!validOptions) {
      Get.snackbar(
        'Error',
        'Please choose valid options',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Repo.demoCarts.add(
      CartItem(
        totalPrice: product.calculateTotalCost() * numberOfItems,
        unitPrice: product.calculateTotalCost(),
        quantity: numberOfItems,
        productId: product.id,
        choosedVariant:
            product.options
                .map((option) => option.choosedVariant)
                .expand((variants) => variants)
                .toList(),
        note: '',
      ),
    );
    Get.back();
    Get.snackbar(
      'Success',
      'Product added to cart',
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(
        child: const Text('go to cart'),
        onPressed: () {
          Get.closeCurrentSnackbar();
          Get.find<NavigationBarController>().setIndex(2);
        },
      ),
    );
  }

  void selectVariant(int optionIndex, Variant variant) {
    if (!product.options[optionIndex].choosedVariant.contains(variant)) {
      if (product.options[optionIndex].max ==
          product.options[optionIndex].choosedVariant.length) {
        product.options[optionIndex].choosedVariant.removeAt(0);
      }
      product.options[optionIndex].choosedVariant.add(variant);
    } else {
      product.options[optionIndex].choosedVariant.remove(variant);
    }
    update();
  }
}
