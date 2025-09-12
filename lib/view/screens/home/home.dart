
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:store_app_v2/data/data_source/static.dart';
import 'package:store_app_v2/view/screens/home/banner_view.dart';
import 'package:store_app_v2/view/screens/home/home_header.dart';
import 'package:store_app_v2/view/global%20widget/product_list.dart';
import 'package:store_app_v2/view/screens/home/special_offers.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/features/banner/domain/repositories/banner_repository.dart';
import 'package:store_app_v2/features/banner/domain/services/banner_service.dart';
import 'package:store_app_v2/features/banner/controllers/banner_controller.dart';
import 'package:store_app_v2/features/category/domain/repositories/category_repository.dart';
import 'package:store_app_v2/features/category/domain/services/category_service.dart';
import 'package:store_app_v2/features/category/controllers/category_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure BannerController is registered once for the session
    if (!Get.isRegistered<BannerController>()) {
      Get.put(
        BannerController(
          bannerServiceInterface: BannerService(
            bannerRepositoryInterface: BannerRepository(
              firestore: FirebaseFirestore.instance,
            ),
          ),
        ),
        permanent: true,
      );
    }
    // Ensure CategoryController is registered once for the session
    if (!Get.isRegistered<CategoryController>()) {
      Get.put(
        CategoryController(
          service: CategoryService(
            repository: CategoryRepository(
              firestore: FirebaseFirestore.instance,
            ),
          ),
        ),
        permanent: true,
      );
    }
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const HomeHeader(),
          
          const BannerView(isFeatured: false),
          const SpecialOffers(),
          const SizedBox(height: 20),
          const ProductList(title: "Popular Products"),
          FutureBuilder(
            future: categories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error loading categories"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No categories available"));
              }
              final fetchedCategories = snapshot.data!;
              log("Fetched categories: ${fetchedCategories.length}");
              return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: fetchedCategories.length,
                  itemBuilder: (context, index) => ProductList(
                        title: fetchedCategories[index].name,
                      ));
            }
          )
        ],
      ),
    ));
  }
}
