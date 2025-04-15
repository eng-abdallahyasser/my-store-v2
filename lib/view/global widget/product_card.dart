import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/data/model/product.dart';
import 'package:store_app_v2/view/screens/details/details_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
  });

  final double width, aspectRetio;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () {
          Get.to(() => DetailsScreen(product: product));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                decoration: BoxDecoration(
                  color: MyColors.matteCharcoal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: product.isInitialezed?
                ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(
                                  product.coverImageUnit8List!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ):
                FutureBuilder(
                    future: product.initializeCoverImage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/images/product_placeholder.jpg",
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(
                                  snapshot.data!.coverImageUnit8List!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "جـ ",
                  style: TextStyle(
                    fontSize: 14,
                    color: MyColors.elsie,
                  ),
                ),
                Text(
                  "${product.price} ",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MyColors.elsie,
                  ),
                ),
                product.oldPrice > product.price
                    ? Text(
                        " ${product.oldPrice} ",
                        style: const TextStyle(
                          color: MyColors.gray,
                          decoration: TextDecoration.lineThrough,
                        ),
                      )
                    : Container(),
                const Spacer(),
                LoveCountBtn(
                  product: product,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LoveCountBtn extends StatefulWidget {
  final Product product;

  const LoveCountBtn({
    super.key,
    required this.product,
  });

  @override
  State<LoveCountBtn> createState() => _LoveCountBtnState();
}

class _LoveCountBtnState extends State<LoveCountBtn> {
  late int count;
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    count = widget.product.favouritecount;
    isFavourite = Repo.favouriteProducts.contains(widget.product.id);
          if (isFavourite) {
        count += 1;
      } 
  }

  Future<void> _onTab() async {
    setState(() {
      isFavourite = !isFavourite;
      if (isFavourite) {
        count += 1;
      } else {
        count -= 1;
      }
    });

    if (isFavourite) {
      Repo.favouriteProducts.add(widget.product.id);
      widget.product.favouritecount;
      await Repo.addToFavorites(widget.product.id);

    } else {
      Repo.favouriteProducts.remove(widget.product.id);
      await Repo.removeFromFavorites(widget.product.id);
    }

    setState(() {
      count = widget.product.favouritecount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTab,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isFavourite
              ? MyColors.elsie.withOpacity(0.2)
              : MyColors.matteCharcoal.withOpacity(0.07),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$count ",
              style: const TextStyle(fontSize: 12),
            ),
            SvgPicture.asset(
              "assets/icons/Heart Icon_2.svg",
              height: 10,
              colorFilter: ColorFilter.mode(
                isFavourite
                    ? const Color(0xFFFF4848)
                    : MyColors.matteCharcoal.withOpacity(0.4),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
