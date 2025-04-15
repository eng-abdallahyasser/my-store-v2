import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/data/model/address.dart';

class AddressPickerBottomSheet extends StatelessWidget {
  final List<Address> addresses;
  final Function onSelectedAddress;
  const AddressPickerBottomSheet(
      {super.key, required this.addresses, required this.onSelectedAddress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 300, // Adjust height as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Your Address",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(addresses[index].address),
                  leading: SvgPicture.asset(
                    "assets/icons/Location point.svg",
                    width: 22,
                    colorFilter: const ColorFilter.mode(MyColors.elsie,
                        BlendMode.srcIn), 
                  ),
                  onTap: () {
                    onSelectedAddress(addresses[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
