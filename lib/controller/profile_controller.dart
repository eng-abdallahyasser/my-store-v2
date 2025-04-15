import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/firebase/auth.dart';

class ProfileController extends GetxController {
  final Auth _auth = Auth();

void logOut() {
  Get.dialog(
    AlertDialog(
      title: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () async {
            Get.back(); // Close the initial confirmation dialog
            Get.dialog(
              const AlertDialog(
                title: Text('Logging out...'),
                content: Center(child: CircularProgressIndicator()),
              ),
              barrierDismissible: false, // Prevent closing the loading dialog
            );
            await _auth.signOut();
            Get.back(); // Close the loading dialog
            Get.offAllNamed(MyRoutes.splashScreen); // Navigate to the splash screen
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Get.back(); // Close the confirmation dialog
          },
          child: const Text('No'),
        ),
      ],
    ),
  );
}


  String getUserName() {
    return _auth.getCurrentUser()!.displayName!;
  }
}
