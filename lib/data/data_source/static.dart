import 'package:store_app_v2/core/constants.dart';
import 'package:store_app_v2/data/model/bottom_bar_destination.dart';
import 'package:store_app_v2/data/model/onboarding.dart';
import 'package:store_app_v2/view/screens/cart/cart.dart';
import 'package:store_app_v2/view/screens/favourite/favourites_screen.dart';
import 'package:store_app_v2/view/screens/home/home.dart';
import 'package:store_app_v2/view/screens/profile/profile.dart';

List<OnboardingData> onboardingList = [
  OnboardingData(
    title: 'Find Favorite Items',
    description:
        'Easily search and discover your favorite products from a wide range of categories. Our platform offers personalized recommendations to help you find exactly what you\'re looking for.',
    imageAssetPath: MyImages.onBoardingImage1,
  ),
  OnboardingData(
    title: 'Easy and Safe Payment',
    description:
        'Experience secure and convenient payment options for a hassle-free shopping experience. Choose from multiple payment methods and rest assured that your transactions are protected.',
    imageAssetPath: MyImages.onBoardingImage2,
  ),
  OnboardingData(
    title: 'Product Delivery',
    description:
        'Get your products delivered swiftly and safely to your doorstep. We ensure timely delivery and provide real-time tracking updates so you can stay informed every step of the way.',
    imageAssetPath: MyImages.onBoardingImage3,
  ),
];

List<BottomBarDestination> bottomBarDestinations = [
  BottomBarDestination(
    icon: "assets/icons/Shop Icon.svg",
    route: MyRoutes.home,
    label: "Home",
    routeWidget: const Home(),
  ),
  BottomBarDestination(
    icon: "assets/icons/Heart Icon.svg",
    route: MyRoutes.categories,
    label: "Favourites",
    routeWidget: const FavouritesScreen(),
  ),
  BottomBarDestination(
    icon: "assets/icons/Cart Icon.svg",
    route: MyRoutes.cart,
    label: "Cart",
    routeWidget: CartScreen(),
  ),
  BottomBarDestination(
    icon: "assets/icons/User Icon.svg",
    route: MyRoutes.profile,
    label: "Profile",
    routeWidget: Profile(),
  )
];

List<String> categories = [
  "Sushi Rolls",
  "Nigiri",
  "Sashimi",
  "Bento Boxes",
  "Side Dishes",
  "Beverages"
];

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";


