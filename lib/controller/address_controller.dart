import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/controller/cart_controller.dart';
import 'package:store_app_v2/data/model/address.dart';
import 'package:store_app_v2/view/screens/addresses/address_detailes.dart';
import 'package:store_app_v2/view/screens/addresses/new_address.dart';

class AddressController extends GetxController {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  Address newAddress = Address(
      addressId: "tempId",
      userId: "TEMP",
      name: "Address Name",
      latitude: 0,
      longitude: 0,
      address: "temp",
      phoneNumber: "temp");

  onTapAddress(Address addressTapped) {
    Get.to(() => AddressDetails(address: addressTapped));
  }

  addNewAddress() async {
    Get.defaultDialog(
        title: 'جاري تحديد موقعك...',
        content: const CircularProgressIndicator());

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      Get.back();
      Get.defaultDialog(
        title: 'خطأ',
        content: const Text(
            'تم رفض إذن الموقع بشكل دائم، لا يمكننا طلب الإذن مرة أخرى. يمكنك تعديل الأذونات من الإعدادات > التطبيقات > الأذونات.'),
      );
    }
    await Geolocator.getCurrentPosition().then((value) {
      newAddress.latitude = value.latitude;
      newAddress.longitude = value.longitude;
    });
    Get.back();
    Get.to(() => NewAddress(
          address: newAddress,
          addressController: addressController,
          phoneController: phoneController,
        ));
  }

  void onSaveNewAddressClicked(Address newAddress) async {
    Get.defaultDialog(
      title: 'جاري الحفظ...',
      content: const CircularProgressIndicator(),
    );
    if (addressController.text.length < 12) {
      Get.back();
      Get.defaultDialog(
        title: 'خطأ',
        content: const Text('يرجى إدخال عنوان صحيح'),
      );
    } else if (phoneController.text.length != 11 ||
        !phoneController.text.startsWith('01')) {
      Get.back();
      Get.defaultDialog(
        title: 'خطأ',
        content: const Text(
            'يرجى إدخال رقم هاتف صحيح، يجب أن يكون 11 رقمًا ويبدأ بـ 01.\n مثال: 01XXXXXXXXX.'),
      );
    } else {
      newAddress.address = addressController.text;
      newAddress.phoneNumber = phoneController.text;
      // Set the real userId before saving
      final user = Repo.auth.getCurrentUser();
      if (user != null) {
        newAddress.userId = user.uid;
      }
      final newId = await Repo.address.addAddress(newAddress);
      newAddress.addressId = newId;
      // Refresh cart addresses and select the newly added one if CartController is active
      if (Get.isRegistered<CartController>()) {
        final cart = Get.find<CartController>();
        await cart.getAddresses();
        cart.selectAddress(newAddress);
      }
      Get.back();
      Get.back();
      update();
    }
  }
}
