import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/controller/navigation_bar_controller.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/data/data_source/static.dart';
import 'package:store_app_v2/data/model/bottom_bar_destination.dart';


class MyNavigationBarWraper extends StatelessWidget {
  final NavigationBarController controller = Get.put(NavigationBarController());
  MyNavigationBarWraper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: bottomBarDestinations
            .map((destination) => destination.routeWidget)
            .toList(),
      ),
      bottomNavigationBar: GetBuilder<NavigationBarController>(
        builder: (controller) => BottomNavigationBar(
          onTap: (index){controller.setIndex(index);},
          currentIndex: controller.selectedIndex,
          selectedItemColor: MyColors.elsie,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: bottomBarDestinations
              .map((destination) => _btmBarItem(destination))
              .toList(),
        ),
      ),
    );
  }

  BottomNavigationBarItem _btmBarItem(BottomBarDestination destination) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        destination.icon,
        colorFilter: const ColorFilter.mode(
          MyColors.gray,
          BlendMode.srcIn,
        ),
      ),
      activeIcon: SvgPicture.asset(
        destination.icon,
        colorFilter: const ColorFilter.mode(
          MyColors.elsie,
          BlendMode.srcIn,
        ),
      ),
      label: destination.label,
    );
  }
}
