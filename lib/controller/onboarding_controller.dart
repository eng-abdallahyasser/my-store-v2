import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/data/data_source/static.dart';

class OnboardingController extends GetxController {
  int currentIndex = 0;
  PageController pageController = PageController();

  void changeIndex(int index) {
    currentIndex = index;
    update();
  }

  void next() {
    if (currentIndex < onboardingList.length - 1) {
      currentIndex++;
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      update();
    }
  }

  void skip() {
    if (currentIndex != onboardingList.length - 1) {
      currentIndex = onboardingList.length - 1;
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      update();
    }
  }

  void onGetStarted() async {
    Repo.prefs.setBool('onboardingShown', true);
    Get.offAllNamed(MyRoutes.signInScreen);
  }
}
