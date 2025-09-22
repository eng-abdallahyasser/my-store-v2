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
  final TextEditingController areaController = TextEditingController(); // منطقة
  final TextEditingController streetController = TextEditingController(); // شارع
  final TextEditingController buildingController = TextEditingController(); // عمارة
  final TextEditingController floorController = TextEditingController(); // دور
  final TextEditingController apartmentController = TextEditingController(); // شقة
  final TextEditingController landmarkController = TextEditingController(); // علامة مميزة
  Address newAddress = Address(
      addressId: "tempId",
      userId: "TEMP",
      name: "Address Name",
      latitude: 0,
      longitude: 0,
      address: "temp",
      phoneNumber: "temp",
      area: "temp",
      street: "temp",
      building: "temp",
      floor: "temp",
      apartment: "temp",
      landmark: "temp");

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
          areaController: areaController,
          streetController: streetController,
          buildingController: buildingController,
          floorController: floorController,
          apartmentController: apartmentController,
          landmarkController: landmarkController,
        ));
  }

  void onSaveNewAddressClicked(Address newAddress) async {
    Get.defaultDialog(
      title: 'جاري الحفظ...',
      content: const CircularProgressIndicator(),
    );
    
    // Validate all required fields
    if (phoneController.text.length != 11 ||
        !phoneController.text.startsWith('01')) {
      Get.back();
      Get.defaultDialog(
        title: 'خطأ',
        content: const Text(
            'يرجى إدخال رقم هاتف صحيح، يجب أن يكون 11 رقمًا ويبدأ بـ 01.\n مثال: 01XXXXXXXXX.'),
      );
    } else if (areaController.text.trim().isEmpty) {
      Get.back();
      Get.defaultDialog(
        title: 'خطأ',
        content: const Text('يرجى إدخال المنطقة'),
      );
    } else if (streetController.text.trim().isEmpty) {
      Get.back();
      Get.defaultDialog(
        title: 'خطأ',
        content: const Text('يرجى إدخال الشارع'),
      );
    } else if (buildingController.text.trim().isEmpty) {
      Get.back();
      Get.defaultDialog(
        title: 'خطأ',
        content: const Text('يرجى إدخال العمارة'),
      );
    } else if (floorController.text.trim().isEmpty) {
      Get.back();
      Get.defaultDialog(
        title: 'خطأ',
        content: const Text('يرجى إدخال الدور'),
      );
    } else if (apartmentController.text.trim().isEmpty) {
      Get.back();
      Get.defaultDialog(
        title: 'خطأ',
        content: const Text('يرجى إدخال الشقة'),
      );
    } else if (landmarkController.text.trim().isEmpty) {
      Get.back();
      Get.defaultDialog(
        title: 'خطأ',
        content: const Text('يرجى إدخال علامة مميزة'),
      );
    } else {
      // Set all address fields
      newAddress.address = addressController.text;
      newAddress.phoneNumber = phoneController.text;
      newAddress.area = areaController.text.trim();
      newAddress.street = streetController.text.trim();
      newAddress.building = buildingController.text.trim();
      newAddress.floor = floorController.text.trim();
      newAddress.apartment = apartmentController.text.trim();
      newAddress.landmark = landmarkController.text.trim();
      
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
      
      // Clear all text controllers after successful save
      addressController.clear();
      phoneController.clear();
      areaController.clear();
      streetController.clear();
      buildingController.clear();
      floorController.clear();
      apartmentController.clear();
      landmarkController.clear();
      
      Get.back();
      Get.back();
      update();
    }
  }
}
