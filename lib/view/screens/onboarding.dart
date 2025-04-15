import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/controller/onboarding_controller.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/data/data_source/static.dart';
import 'package:store_app_v2/data/model/onboarding.dart';

class Onboarding extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());
  Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.white,
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.changeIndex(index);
                },
                itemCount: onboardingList.length,
                itemBuilder: (context, index) =>
                    _onboardingSection(onboardingList[index], context),
              ),
            ),
            Expanded(
                flex: 2,
                child: GetBuilder<OnboardingController>(builder: (_) {
                  return _onboardingController();
                }))
          ],
        ));
  }

  Widget _onboardingController() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                  onboardingList.length,
                  (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: controller.currentIndex == index ? 18 : 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: controller.currentIndex == index
                              ? MyColors.elsie
                              : MyColors.gray,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ))
            ],
          ),
          const Spacer(),
          _onboardingButtons(),
        ],
      ),
    );
  }

  Row _onboardingButtons() {
    if (controller.currentIndex < 2) {
      return Row(
        children: [
          InkWell(
            onTap: controller.skip,
            child: const Text(
              "Skip",
              style: TextStyle(fontSize: 22, color: MyColors.gray),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: controller.next,
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.elsie,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 8.0,
                ),
                child: Text("Next",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: MyColors.white)),
              ),
            ),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              controller.onGetStarted();
               
            },
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.elsie,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 100.0,
                  vertical: 8.0,
                ),
                child: Text("Start !",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: MyColors.white)),
              ),
            ),
          )
        ],
      );
    }
  }

  Widget _onboardingSection(OnboardingData data, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Image.asset(data.imageAssetPath),
        ),
        const SizedBox(height: 20),
        Text(
          data.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            data.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
