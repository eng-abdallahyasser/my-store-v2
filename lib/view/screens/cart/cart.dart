import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/controller/cart_controller.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/view/screens/cart/address_picker.dart';
import 'package:store_app_v2/view/screens/cart/check_out_card.dart';
import 'package:store_app_v2/view/screens/cart/cart_card.dart';

class CartScreen extends StatelessWidget {
  final CartController controller = Get.put(CartController());

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (controller) {
      controller.calculateTotal();
      controller.getAddresses();
      return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              const Text(
                "Your Cart",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "${controller.cartList.length} items",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: controller.cartList.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.cartList.length,
                        itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CartCard(
                              product: Repo.getFetchedProductById(
                                  controller.cartList[index].productId),
                              cart: controller.cartList[index],
                              add: () {
                                controller.addOneProduct(index);
                              },
                              remove: () {
                                controller.removeOneProduct(index);
                              },
                            )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showAddressPicker(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (controller.selectedAddress.latitude == 0.0)
                                        ? "Tap to select an address"
                                        : controller.selectedAddress.address,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  SvgPicture.asset(
                                    "assets/icons/arrow_down.svg",
                                    width: 22,
                                    colorFilter: const ColorFilter.mode(
                                        MyColors.elsie, BlendMode.srcIn),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    "No items in cart",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
        ),
        bottomNavigationBar: CheckoutCard(
          controller: controller,
        ),
      );
    });
  }

  void _showAddressPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)), // Rounded corners
      ),
      builder: (context) {
        return AddressPickerBottomSheet(
          addresses: controller.addresses,
          onSelectedAddress: (selectedAddress) {
            controller.selectAddress(selectedAddress);
            Navigator.pop(context); // Close the bottom sheet
          },
        );
      },
    );
  }
}
