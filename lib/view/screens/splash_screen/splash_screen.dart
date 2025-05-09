import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/firebase/auth.dart';
import 'package:store_app_v2/view/screens/auth/signin.dart';
import 'package:store_app_v2/view/screens/navigation%20wraper/my_navigation_bar.dart';
import 'package:store_app_v2/view/screens/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = Auth();
  @override
  void initState() {
    Timer(const Duration(milliseconds: 2000), () {
      Get.off(() => Repo.onboardingShown ? _authGate() : Onboarding());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child:
                    ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                    child: Image.asset("assets/images/logo.jpg")),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Developed by Eng",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "ABDALLAH YASSER",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B262C)),
              ),
            ],
          ),
        ));
  }

  Widget _authGate() {
    return FutureBuilder(
        future: _auth.getCurrentUserFuture(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return MyNavigationBarWraper();
          } else {
            return SignInScreen();
          }
        });
  }
}
