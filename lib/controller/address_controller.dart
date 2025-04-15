import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
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
        title: 'Finding your location',
        content: const CircularProgressIndicator());

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      Get.back();
      Get.defaultDialog(
        title: 'ERROR',
        content: const Text(
            'Location Permission are permanently denied, we cannot request permission again but you can check permissions by going to settings > apps > permissions'),
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
      title: 'Saving',
      content: const CircularProgressIndicator(),
    );
    if (addressController.text.length < 12) {
      Get.back();
      Get.defaultDialog(
        title: 'ERROR',
        content: const Text('Please, enter a valid address'),
      );
    } else if (phoneController.text.length != 11 ||
        !phoneController.text.startsWith('01')) {
      Get.back();
      Get.defaultDialog(
        title: 'ERROR',
        content: const Text(
            'Please, enter a valid phone number, it should be 11 digits and start with 01. \n For example: 01XXXXXXXXX.'),
      );
    } else {
      newAddress.address = addressController.text;
      newAddress.phoneNumber = phoneController.text;
      await Repo.addAddress(newAddress);
      Get.back();
      Get.back();
      update();
    }
  }
}
