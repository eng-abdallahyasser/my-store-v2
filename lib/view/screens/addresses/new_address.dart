import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:store_app_v2/controller/address_controller.dart';
import 'package:store_app_v2/data/model/address.dart';
import 'package:store_app_v2/view/global%20widget/my_button.dart';
import 'package:store_app_v2/view/global%20widget/my_textfield.dart';
import 'package:store_app_v2/view/screens/addresses/small_map_card.dart';

class NewAddress extends StatelessWidget {
  final AddressController controller = Get.find();
  final Address address;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController areaController;
  final TextEditingController streetController;
  final TextEditingController buildingController;
  final TextEditingController floorController;
  final TextEditingController apartmentController;
  final TextEditingController landmarkController;

  NewAddress(
      {super.key,
      required this.address,
      required this.addressController,
      required this.phoneController,
      required this.areaController,
      required this.streetController,
      required this.buildingController,
      required this.floorController,
      required this.apartmentController,
      required this.landmarkController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Address'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SmallMapCard(
                  location: LatLng(address.latitude, address.longitude),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "latitude = ${address.latitude.toString()} & longitude = ${address.longitude.toString()}",
                ),
              ),
              const SizedBox(height: 10),
              MyTextfield(
                hintText: "Your Address",
                controller: addressController,
              ),
              const SizedBox(height: 10),
              MyTextfield(
                hintText: "Phone Number",
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              MyTextfield(
                hintText: "المنطقة",
                controller: areaController,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: MyTextfield(
                      hintText: "الشارع",
                      controller: streetController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyTextfield(
                      hintText: "العمارة",
                      controller: buildingController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: MyTextfield(
                      hintText: "الدور",
                      controller: floorController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyTextfield(
                      hintText: "الشقة",
                      controller: apartmentController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              MyTextfield(
                hintText: "علامة مميزة",
                controller: landmarkController,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  controller.onSaveNewAddressClicked(address);
                },
                child: const MyButton(text: "Save Address"),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
