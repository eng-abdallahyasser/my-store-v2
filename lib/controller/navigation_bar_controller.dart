import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationBarController extends GetxController {
  int selectedIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  void setIndex(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      pageController.jumpToPage(index);
      update();
    }
  }
}
