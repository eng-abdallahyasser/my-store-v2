import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/controller/address_controller.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/data/model/address.dart';
import 'package:store_app_v2/view/screens/addresses/address_cart.dart';

class AddressScreen extends StatelessWidget {
  final AddressController controller = Get.put(AddressController());
  AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Addresses"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder<AddressController>(
              builder: (context) {
                return FutureBuilder(
                  future: Repo.getAddresses(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error..."),
                      );
                    }
                    if (snapshot.hasData) {
                      var addresses = snapshot.data as List<Address>;
                      if (addresses.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          return AddressCart(
                              address:
                                  addresses[index]); // Correct way to pass address
                        },
                      );
                      
                    }
                    return const SizedBox
                                  .shrink(); // here by default width and height is 0
                  },
                );
              }
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {controller.addNewAddress()},
        child: const Icon(Icons.add),
      ),
    );
  }
}
