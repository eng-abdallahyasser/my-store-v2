import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/firebase/auth.dart';
import 'package:store_app_v2/routes/my_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/data_source/repo.dart';

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
      Get.defaultDialog(title: 'خطأ', middleText: 'يرجى ملء جميع الحقول.');
    } else {
      Get.dialog(
        const AlertDialog(
          title: Text('جاري تسجيل الدخول...'),
          content: SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
      String massage = await _auth.signIn(
        emailController.text,
        pwController.text,
      );
      Get.back();
      if (massage == "Signed in") {
        Get.offAllNamed(MyRoutes.navigationBarWraper);
      }
      if (massage == 'invalid-email') {
        Get.defaultDialog(
          title: 'خطأ',
          middleText:
              'البريد الإلكتروني غير صالح. يرجى إدخال بريد إلكتروني صحيح.',
        );
      }
      if (massage == 'invalid-credential') {
        Get.defaultDialog(
          title: 'خطأ',
          middleText:
              'بيانات الاعتماد غير صحيحة. يرجى التحقق من البريد الإلكتروني وكلمة المرور.',
        );
      }
    }
  }
}

extension GoogleSignInController on SignInController {
  Future<void> googleSignIn() async {
    Get.dialog(
      const AlertDialog(
        title: Text('جاري تسجيل الدخول...'),
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
    String message = await _auth.signInWithGoogle();
    Get.back();
    if (message == "Signed in") {
      // After successful Google sign-in, ensure the user accepted terms
      final user = _auth.getCurrentUser();
      if (user == null) {
        // Unexpected - user should be signed in; just navigate for safety
        Get.offAllNamed(MyRoutes.navigationBarWraper);
        return;
      }

      // Check user's acceptedTerms flag in Firestore
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final raw = userDoc.data();
      bool accepted = false;
      if (raw is Map<String, dynamic>) {
        accepted = raw['acceptedTerms'] == true;
      }

      if (!accepted) {
        // Show the latest terms and require acceptance
        final terms = await Repo.terms.getLatestTerms();
        String content = terms?.content ?? 'الشروط والأحكام';

        final acceptedNow = await Get.defaultDialog<bool>(
          title: terms?.title ?? 'الشروط والأحكام',
          content: Container(
            // Use content instead of middleText
            constraints: BoxConstraints(
              maxHeight: Get.height * 0.6, // Limit height to 60% of screen
            ),
            child: SingleChildScrollView(
              child: Text(
                content,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
          ),
          textConfirm: 'اقبال',
          textCancel: 'الانسحاب',
          barrierDismissible: false,
          confirmTextColor: Colors.white,
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
        );
        if (acceptedNow == true) {
          // Persist acceptance in user's Firestore doc
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'acceptedTerms': true,
                'acceptedTermsAt': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));

          Get.offAllNamed(MyRoutes.navigationBarWraper);
          return;
        } else {
          // User declined terms — sign them out and show message
          await _auth.signOut();
          Get.defaultDialog(
            title: 'التوجه',
            middleText:
                'تحتاج موافقة الشروط والأحكام. لتسجيل استخدامك، يمكننا إنشاء حساب.',
          );
          return;
        }
      }

      // Already accepted
      Get.offAllNamed(MyRoutes.navigationBarWraper);
      return;
    }
    if (message == 'cancelled') {
      // User cancelled the Google flow; no dialog necessary.
      return;
    }
    Get.defaultDialog(
      title: 'خطأ',
      middleText: 'فشل تسجيل الدخول عبر Google: $message',
    );
  }
}
