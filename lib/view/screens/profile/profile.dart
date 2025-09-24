import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/controller/profile_controller.dart';
import 'package:store_app_v2/core/app_utils.dart';
import 'package:store_app_v2/view/screens/addresses/address.dart';
import 'package:store_app_v2/view/screens/orders/orders_list_screen.dart';
import 'package:store_app_v2/view/screens/profile/components/profile_menu.dart';
import 'package:store_app_v2/view/screens/profile/components/profile_pic.dart';
import 'package:store_app_v2/view/screens/support/feedback_screen.dart';
import 'package:store_app_v2/view/screens/support/terms_screen.dart';
import 'package:store_app_v2/view/screens/support/privacy_policy_screen.dart';
import 'package:store_app_v2/routes/my_routes.dart';


class Profile extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            Text(controller.getUserName()),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () => {},
            ),
            ProfileMenu(
              text: "My Addresses",
              icon: "assets/icons/Location point.svg",
              press: () {
                Get.to(() => AddressScreen());
              },
            ),
            ProfileMenu(
              text: "My Orders",
              icon: "assets/icons/Cart Icon.svg",
              press: () {
                Get.to(() => OrdersListScreen());
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {
                Get.toNamed(MyRoutes.notifications);
              },
            ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Terms & Conditions",
              icon: "assets/icons/Question mark.svg",
              press: () {
                Get.to(() => const TermsScreen());
              },
            ),
            ProfileMenu(
              text: "Privacy Policy",
              icon: "assets/icons/Question mark.svg",
              press: () {
                Get.to(() => const PrivacyPolicyScreen());
              },
            ),
            ProfileMenu(
              text: "Suggestions & Complaints",
              icon: "assets/icons/Question mark.svg",
              press: () {
                Get.to(() => const FeedbackScreen());
              },
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: controller.logOut,
            ),
            const SizedBox(height: 20),
            FutureBuilder<String>(
              future: AppUtils.getAppVersion(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                if (snapshot.hasData) {
                  return Text(
                    'App version: ${snapshot.data}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
