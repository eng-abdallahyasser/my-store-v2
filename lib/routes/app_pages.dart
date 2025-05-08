import 'package:get/get.dart';
import 'package:store_app_v2/routes/my_routes.dart';
import 'package:store_app_v2/view/global%20widget/search.dart';
import 'package:store_app_v2/view/screens/addresses/address.dart';
import 'package:store_app_v2/view/screens/auth/signin.dart';
import 'package:store_app_v2/view/screens/auth/signup.dart';
import 'package:store_app_v2/view/screens/cart/cart.dart';
import 'package:store_app_v2/view/screens/home/home.dart';
import 'package:store_app_v2/view/screens/navigation%20wraper/my_navigation_bar.dart';
import 'package:store_app_v2/view/screens/onboarding.dart';
import 'package:store_app_v2/view/screens/profile/profile.dart';
import 'package:store_app_v2/view/screens/splash_screen/splash_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: MyRoutes.onboarding,
      page: () => Onboarding(),
    ),
    GetPage(
      name: MyRoutes.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: MyRoutes.signInScreen,
      page: () => SignInScreen(),
    ),
    GetPage(
      name: MyRoutes.signUpScreen,
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: MyRoutes.home,
      page: () => const Home(),
    ),
    GetPage(
      name: MyRoutes.cart,
      page: () => CartScreen(),
    ),
    GetPage(
      name: MyRoutes.profile,
      page: () => Profile(),
    ),
    GetPage(
      name: MyRoutes.search,
      page: () => const Search(),
    ),
    GetPage(
      name: MyRoutes.navigationBarWraper,
      page: () => MyNavigationBarWraper(),
    ),
    GetPage(
      name: MyRoutes.addressScreen,
      page: () => AddressScreen(),
    ),
  ];
}