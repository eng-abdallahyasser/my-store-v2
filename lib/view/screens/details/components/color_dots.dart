import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:store_app_v2/controller/detailes_screen_controller.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/data/model/product.dart';
import 'package:store_app_v2/view/global%20widget/rounded_icon_btn.dart';

class ColorDots extends StatelessWidget {
  const ColorDots({
    super.key,
    required this.product,
    required this.controller,
  });

  final Product product;
  final DetailesScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ...List.generate(
            product.colors.length,
            (index) => GestureDetector(
              onTap: () {
                controller.selectColorIndex(index);
              },
              child: GetBuilder<DetailesScreenController>(
                builder: (controller) {
                  return ColorDot(
                    color: product.colors[index],
                    isSelected: index == controller.selectedColor,
                  );
                }
              ),
            ),
          ),
          const Spacer(),
          RoundedIconBtn(
            icon: Icons.remove,
            press: controller.removeOneItem,
          ),
          const SizedBox(width: 20),
          RoundedIconBtn(
            icon: Icons.add,
            showShadow: true,
            press: controller.addOneItem,
          ),
        ],
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  const ColorDot({
    super.key,
    required this.color,
    required this.isSelected,
  });

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 2),
      padding: const EdgeInsets.all(8),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border:
            Border.all(color: isSelected ? MyColors.elsie : Colors.transparent),
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
