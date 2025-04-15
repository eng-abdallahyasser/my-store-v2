import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/firebase/auth.dart';

class SignInController extends GetxController {
  final Auth _auth = Auth();

  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  bool showPassword = false;

  void hidePassword() {
    showPassword = !showPassword;
    update();
  }

  Future<void> signIn() async {
    if (emailController.text.isEmpty || pwController.text.isEmpty) {
      Get.defaultDialog(
        title: 'Error',
        middleText: 'Please fill all the fields',
      );
    } else {
      Get.dialog(const AlertDialog(
        title: Text('Signing In...'),
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ));
      String massage =
          await _auth.signIn(emailController.text, pwController.text);
      Get.back();
      if (massage == "Signed in") {
        Get.offAllNamed(MyRoutes.navigationBarWraper);
      }
      if (massage == 'invalid-email') {
        Get.defaultDialog(
          title: 'Error',
          middleText: 'دا مش شكل ايميل يا واجهة',
        );
      }
      if (massage == 'invalid-credential') {
        Get.defaultDialog(
          title: 'Error',
          middleText: 'جدع، نسيت الباسورد ولا الأيميل ولا كتبتهم غلط ؟',
        );
      }
    }
  }
}
