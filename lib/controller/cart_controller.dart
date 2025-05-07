import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/data/model/address.dart';
import 'package:store_app_v2/data/model/cart_item.dart';
import 'package:store_app_v2/data/model/my_order.dart';
import 'package:store_app_v2/view/screens/addresses/address.dart';

class CartController extends GetxController {
  List<CartItem> cartList = Repo.demoCarts;
  double total = 0.0;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  List<Address> addresses = [];
  Address selectedAddress = Address(
    userId: "userId",
    addressId: "addressId",
    name: "name",
    latitude: 0,
    longitude: 0,
    address: "address",
    phoneNumber: "phoneNumber",
  );

  @override
  void onInit() async {
    calculateTotal();
    getAddresses();
    super.onInit();
  }

  void getAddresses() async {
    addresses = await Repo.getAddresses();
  }

  void calculateTotal() {
    total = 0.0;
    for (var cartItem in cartList) {
      total += cartItem.totalPrice;
    }
    update();
  }

  void removeOneProduct(int index) {
    if (cartList[index].quantity > 1) {
      cartList[index]= cartList[index].copyWith(
        quantity: cartList[index].quantity - 1,
        totalPrice: cartList[index].totalPrice - cartList[index].unitPrice,
      );
    } else if (cartList[index].quantity == 1) {
      Get.dialog(
        AlertDialog(
          title: const Text("Are you sure?"),
          actions: [
            TextButton(
              onPressed: () {
                cartList.removeAt(index);
                Get.back();
                calculateTotal();
              },
              child: const Text("Yes, Remove It"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("No"),
            ),
          ],
        ),
      );
    }
    calculateTotal();
  }

  void addOneProduct(int index) {
    cartList[index]= cartList[index].copyWith(
      quantity: cartList[index].quantity + 1,
      totalPrice: cartList[index].totalPrice + cartList[index].unitPrice,
    );
    calculateTotal();
  }

  void saveOrder() async {
    // add progress indcator here
    Get.defaultDialog(
      title: "Saving Your Order",
      content: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text("Please wait..."),
        ],
      ),
    );

    MyOrder order = MyOrder(
      id: "",
      userId: "",
      customerPhone: selectedAddress.phoneNumber,
      shippingAddress: selectedAddress.addressId,
      items: cartList,
      total:total,
      status: "Pending",
      createdAt:Timestamp.now(),
      paymentStatus: "unpaid",
      customerName: "customerName",
      customerEmail: "customerEmail",
    );

    //saving order ....
    await Repo.addOrder(order);

    cartList.clear();
    update(); // this update is not working i dont know why?

    // close it after finishing
    Get.back();
    Get.snackbar(
      "Success",
      "Your Order Saved successfully",
      snackPosition: SnackPosition.TOP,
    );
  }

  void placeOreder() async {
    // add progress indcator here
    Get.defaultDialog(
      title: "Saving Your Order",
      content: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text("laoding"),
        ],
      ),
    );
    List<Address> addresses = await Repo.getAddresses();
    if (addresses.isEmpty) {
      Get.back();
      Get.snackbar(
        "Error",
        "Please add your address first",
        duration: const Duration(seconds: 10),
      );
      Get.to(() => AddressScreen());
    } else if (selectedAddress.latitude == 0) {
      Get.back();
      Get.snackbar(
        "Error",
        "Please select your address first",
        duration: const Duration(seconds: 10),
      );
    } else {
      Get.back();
      Get.defaultDialog(
        title: "Confirm Your Address",
        content: Column(
          children: [
            const SizedBox(height: 20),
            Text(selectedAddress.address),
            const SizedBox(height: 20),
            Text(selectedAddress.phoneNumber),
            const SizedBox(height: 20),
          ],
        ),
        onConfirm: () {
          Get.back();
          saveOrder();
        },
        textConfirm: "Confirm",
        onCancel: () {
          Get.back();
        },
      );
    }
  }

  void selectAddress(addressTapped) {
    selectedAddress = addressTapped;
    update();
  }
}
