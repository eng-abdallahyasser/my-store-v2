import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/firebase/auth.dart';
import 'package:store_app_v2/routes/my_routes.dart';

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
        title: 'خطأ',
        middleText: 'يرجى ملء جميع الحقول.',
      );
    } else {
      Get.dialog(const AlertDialog(
        title: Text('جاري تسجيل الدخول...'),
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
          title: 'خطأ',
          middleText: 'البريد الإلكتروني غير صالح. يرجى إدخال بريد إلكتروني صحيح.',
        );
      }
      if (massage == 'invalid-credential') {
        Get.defaultDialog(
          title: 'خطأ',
          middleText: 'بيانات الاعتماد غير صحيحة. يرجى التحقق من البريد الإلكتروني وكلمة المرور.',
        );
      }
    }
  }
}
