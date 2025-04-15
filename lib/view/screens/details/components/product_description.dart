import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:store_app_v2/controller/detailes_screen_controller.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/data/model/product.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    super.key,
    required this.product,
    this.pressOnSeeMore,
  });

  final Product product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            product.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GetBuilder<DetailesScreenController>(builder: (controller) {
            return GestureDetector(
              onTap: controller.onAddToFavouritesTap,
              child: Container(
                padding: const EdgeInsets.all(16),
                // width: 48,
                decoration: BoxDecoration(
                  color:Repo.favouriteProducts.contains(product.id)
                      ? const Color(0xFFFFE6E6)
                      : const Color(0xFFF5F6F9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Add this line
                  children: [
                    Text(controller.favouriteCount.toString()),
                    const SizedBox(
                        width:
                            8), // Add some spacing between the text and icon if needed

                    SvgPicture.asset(
                      "assets/icons/Heart Icon_2.svg",
                      colorFilter: ColorFilter.mode(
                          Repo.favouriteProducts.contains(product.id)
                              ? const Color(0xFFFF4848)
                              : const Color(0xFFDBDEE4),
                          BlendMode.srcIn),
                      height: 16,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            product.description,
            maxLines: 3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: GestureDetector(
            onTap: () {},
            child: const Row(
              children: [
                Text(
                  "See More Detail",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: MyColors.elsie),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: MyColors.elsie,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
