import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:store_app_v2/controller/detailes_screen_controller.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/data/model/option.dart';

class OptionChooser extends StatelessWidget {
  /// A list of variant groups. Each inner list represents a group of options.
  final List<Option> options;
  final DetailesScreenController controller;


  const OptionChooser({
    super.key,
    required this.options,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
      
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(options.length, (optionIndex) {
          // Wrap each group's row in an Obx to update when selection changes.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Optional label for the group.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  options[optionIndex].optionName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              GetBuilder<DetailesScreenController>(builder:  (controller) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: options[optionIndex].variants.map((variant) {
                      bool isSelected = options[optionIndex].choosedVariant.contains(variant);
      
                      return GestureDetector(
                        onTap: () {
                          controller.selectVariant(optionIndex, variant);
                          // If every group has a selection, invoke the callback.
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? MyColors.elsie : Colors.grey,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Text(
                                variant.name,
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '\$${variant.price.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}
