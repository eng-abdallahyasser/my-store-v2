import 'package:get/get.dart';

class NavigationBarController extends GetxController {
  int selectedIndex = 0;

  void setIndex(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      update();
    }
  }
}


