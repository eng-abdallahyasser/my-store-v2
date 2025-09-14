import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/firebase/auth.dart';
import 'package:store_app_v2/routes/my_routes.dart';

class SignUpController extends GetxController {
  final Auth _auth = Auth();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController confirmPwController = TextEditingController();
  bool showPassword = false;
  bool showConfirmPassword = false;

  void hidePassword() {
    showPassword = !showPassword;
    update();
  }

  void hideConfirmPassword() {
    showConfirmPassword = !showConfirmPassword;
    update();
  }

  Future<void> signUp() async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        pwController.text.isNotEmpty &&
        confirmPwController.text.isNotEmpty) {
      if (pwController.text == confirmPwController.text) {
        Get.dialog(const AlertDialog(
          title: Text('جاري إنشاء الحساب...'),
          content: SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
        ));
        String massage = await _auth.signUp(
            emailController.text, pwController.text, nameController.text);
        Get.back();
        if (massage == "Signed up") {
          Get.offAllNamed(MyRoutes.navigationBarWraper);
        }
        if (massage == 'weak-password') {
          Get.defaultDialog(
            title: 'خطأ',
            middleText: 'كلمة المرور ضعيفة. يرجى اختيار كلمة مرور أقوى.',
          );
        }
        if (massage == 'invalid-email') {
          Get.defaultDialog(
            title: 'خطأ',
            middleText: 'البريد الإلكتروني غير صالح. يرجى إدخال بريد إلكتروني صحيح.',
          );
        }
        if (massage == 'email-already-in-use') {
          Get.defaultDialog(
            title: 'خطأ',
            middleText: 'هذا البريد الإلكتروني مستخدم بالفعل. إذا نسيت كلمة المرور، يرجى محاولة الاستعادة.',
          );
        }
      } else {
        Get.defaultDialog(
          title: 'خطأ',
          middleText: 'كلمة المرور وتأكيدها غير متطابقين.',
        );
      }
    } else {
      Get.defaultDialog(
        title: 'خطأ',
        middleText: 'يرجى ملء جميع الحقول.',
      );
    }
    
  }
}
