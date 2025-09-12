import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:store_app_v2/features/banner/controllers/banner_controller.dart';

class BannerView extends StatelessWidget {
  final bool isFeatured;
  const BannerView({super.key, required this.isFeatured});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      final List<String?>? bannerList =
          isFeatured ? bannerController.featuredBannerList : bannerController.bannerImageList;
      final List<dynamic>? bannerDataList =
          isFeatured ? bannerController.featuredBannerDataList : bannerController.bannerDataList;

      if (bannerList == null) {
        // Loading placeholder while fetching from Firebase
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.45,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      }

      if (bannerList.isEmpty) {
        return const SizedBox();
      }

      final Size size = MediaQuery.of(context).size;
      return Container(
        width: size.width,
        height: size.width * 0.5,
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  viewportFraction: 0.8,
                  autoPlayInterval: const Duration(seconds: 7),
                  onPageChanged: (index, reason) {
                    bannerController.setCurrentIndex(index, true);
                  },
                ),
                itemCount: bannerList.length,
                itemBuilder: (context, index, _) {
                  return InkWell(
                    onTap: () async {
                      if (bannerDataList != null && bannerDataList[index] is String) {
                        final String url = bannerDataList[index] as String;
                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(url, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Unable to open the link')),
                          );
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                            spreadRadius: 1,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          bannerList[index] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: bannerList.map((bnr) {
                final int index = bannerList.indexOf(bnr);
                final int totalBanner = bannerList.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: index == bannerController.currentIndex
                      ? Container(
                          decoration: BoxDecoration(
                            color: MyColors.mainColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          child: Text(
                            '${index + 1}/$totalBanner',
                            style: TextStyle(color: Theme.of(context).cardColor, fontSize: 12),
                          ),
                        )
                      : Container(
                          height: 5,
                          width: 6,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                );
              }).toList(),
            ),

          ],
        ),
      );
    });
  }
}
