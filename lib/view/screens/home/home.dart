import 'package:flutter/material.dart';
import 'package:store_app_v2/data/data_source/static.dart';
import 'package:store_app_v2/view/screens/home/app_hortcuts.dart';
import 'package:store_app_v2/view/screens/home/home_header.dart';
import 'package:store_app_v2/view/global%20widget/product_list.dart';
import 'package:store_app_v2/view/screens/home/special_offers.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const HomeHeader(),
          const AppShortcuts(),
          const SpecialOffers(),
          const SizedBox(height: 20),
          const ProductList(title: "Popular Products"),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) => ProductList(
                    title: categories[index],
                  ))
        ],
      ),
    ));
  }
}
