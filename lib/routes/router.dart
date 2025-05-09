import 'package:flutter/material.dart';
import 'package:store_app_v2/routes/my_routes.dart';
import 'package:store_app_v2/view/screens/addresses/address.dart';
import 'package:store_app_v2/view/screens/auth/signin.dart';
import 'package:store_app_v2/view/screens/auth/signup.dart';
import 'package:store_app_v2/view/screens/cart/cart.dart';
import 'package:store_app_v2/view/screens/home/home.dart';
import 'package:store_app_v2/view/screens/navigation%20wraper/my_navigation_bar.dart';
import 'package:store_app_v2/view/screens/onboarding.dart';
import 'package:store_app_v2/view/screens/profile/profile.dart';
import 'package:store_app_v2/view/global%20widget/search.dart';
import 'package:store_app_v2/view/screens/splash_screen/splash_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  MyRoutes.onboarding: (_) => Onboarding(),
  MyRoutes.splashScreen: (_) => const SplashScreen(),
  MyRoutes.signInScreen: (_) => SignInScreen(),
  MyRoutes.signUpScreen: (_) => SignUpScreen(),
  MyRoutes.home: (_) => const Home(),
  MyRoutes.cart: (_) => CartScreen(),
  MyRoutes.profile: (_) => Profile(),
  MyRoutes.search: (_) => const Search(),
  MyRoutes.navigationBarWraper: (_) => MyNavigationBarWraper(),
  MyRoutes.addressScreen: (_)=> AddressScreen(),
};
