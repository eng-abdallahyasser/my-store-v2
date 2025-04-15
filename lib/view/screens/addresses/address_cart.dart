// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:store_app_v2/data/model/address.dart';

class AddressCart extends StatelessWidget {
  final Address address;
  const AddressCart({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [           
                  Text(address.name),
                  Text(address.phoneNumber),
                ],
              ),
            ),
            Text(address.address),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
