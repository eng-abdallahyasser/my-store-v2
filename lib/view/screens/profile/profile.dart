import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/controller/profile_controller.dart';
import 'package:store_app_v2/view/screens/addresses/address.dart';
import 'package:store_app_v2/view/screens/profile/components/profile_menu.dart';
import 'package:store_app_v2/view/screens/profile/components/profile_pic.dart';

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
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: controller.logOut,
            ),
            const SizedBox(height: 20),
            // FutureBuilder(
            //     future: AppUtils.getAppVersion(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return Text(snapshot.data);
            //       }
            //       return const SizedBox.shrink();
            //     }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
