import 'dart:developer';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:store_app_v2/routes/app_pages.dart';
import 'package:store_app_v2/routes/my_routes.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> _isOutdated() async {
  final doc = await FirebaseFirestore.instance
      .collection('status')
      .doc('main_restaurant')
      .get();
  final minAppVersion = (doc.data() ?? const {})['minAppVersion']?.toString();
  if (minAppVersion == null || minAppVersion.isEmpty) return false;

  final info = await PackageInfo.fromPlatform();
  final current = info.version; // e.g., 1.0.2

  int _cmp(String a, String b) {
    List<int> pa = a.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> pb = b.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    while (pa.length < 3) pa.add(0);
    while (pb.length < 3) pb.add(0);
    for (int i = 0; i < 3; i++) {
      if (pa[i] != pb[i]) return pa[i] - pb[i];
    }
    return 0;
  }

  return _cmp(current, minAppVersion) < 0; // current < min
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Repo.init();

  final outdated = await _isOutdated();
  if (outdated) {
    runApp(const UpdateRequiredApp());
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16, color: MyColors.gray),
        ),
      ),
      // Ensure all screens respect bottom system insets (Android nav bar)
      // while keeping AppBars aligned with the status bar area.
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        return SafeArea(
          top: false, // AppBar already handles top insets
          bottom: true, // prevent content from going under system nav bar
          child: child,
        );
      },
      initialRoute: MyRoutes.splashScreen,
      getPages: AppPages.routes,
      // routes: routes,
    );
  }
}

class UpdateRequiredApp extends StatelessWidget {
  const UpdateRequiredApp({super.key});

  Future<void> _openStore() async {
    // TODO: replace with your real app store URL
    const url = 'https://play.google.com/store/apps/details?id=com.example.app';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'تحديث مطلوب',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'يجب تحديث التطبيق إلى آخر إصدار لمتابعة الاستخدام.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _openStore,
                  child: const Text('تحديث الآن'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('خروج'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void uploadProducts() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  for (var product in Repo.testProducts) {
    await firestore.collection("products").doc(product["id"]).set(product);
  }

  log("✅ Products uploaded successfully!");

}
