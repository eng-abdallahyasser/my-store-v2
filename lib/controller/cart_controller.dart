import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/data/model/address.dart';
import 'package:store_app_v2/data/model/cart_item.dart';
import 'package:store_app_v2/data/model/my_order.dart';
import 'package:store_app_v2/data/model/restaurant_status.dart';
import 'package:store_app_v2/view/screens/addresses/address.dart';

class CartController extends GetxController {
  List<CartItem> cartList = [];
  double total = 0.0;

  List<Address> addresses = [];
  Address selectedAddress = Address(
    userId: "userId",
    addressId: "addressId",
    name: "name",
    latitude: 0,
    longitude: 0,
    address: "address",
    phoneNumber: "phoneNumber",
    area: "",
    street: "",
    building: "",
    floor: "",
    apartment: "",
    landmark: "",
  );

  StreamSubscription<QuerySnapshot>? _addressesSub;

  @override
  void onInit() async {
    calculateTotal();
    getAddresses();
    _startAddressesListener();
    super.onInit();
  }

  Future<void> getAddresses() async {
    addresses = await Repo.address.getAddresses(
      Repo.auth.getCurrentUser()!.uid,
    );
    // Auto-select a default address if none selected yet
    if (selectedAddress.latitude == 0 && addresses.isNotEmpty) {
      selectedAddress = addresses.first;
    }
    update();
  }

  void _startAddressesListener() {
    final user = Repo.auth.getCurrentUser();
    if (user == null) return;
    _addressesSub?.cancel();
    _addressesSub = FirebaseFirestore.instance
        .collection('addresses')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      addresses = snapshot.docs
          .map((doc) => Address.fromMap(Map<String, dynamic>.from(doc.data())))
          .toList();
      if ((selectedAddress.latitude == 0 ||
              !addresses.any((a) => a.addressId == selectedAddress.addressId)) &&
          addresses.isNotEmpty) {
        selectedAddress = addresses.first;
      }
      update();
    });
  }

  @override
  void onClose() {
    _addressesSub?.cancel();
    super.onClose();
  }

  void addToCart(CartItem cartItem) {
    cartList.add(cartItem);
    calculateTotal();
  }

  void calculateTotal() {
    total = 0.0;
    for (var cartItem in cartList) {
      total += cartItem.totalPrice;
    }
    update();
  }

  void removeOneProduct(int index) {
    if (cartList[index].quantity > 1) {
      cartList[index] = cartList[index].copyWith(
        quantity: cartList[index].quantity - 1,
        totalPrice: cartList[index].totalPrice - cartList[index].unitPrice,
      );
    } else if (cartList[index].quantity == 1) {
      Get.dialog(
        AlertDialog(
          title: const Text("هل أنت متأكد؟"),
          actions: [
            TextButton(
              onPressed: () {
                cartList.removeAt(index);
                Get.back();
                calculateTotal();
              },
              child: const Text("نعم، احذفها"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("لا"),
            ),
          ],
        ),
      );
    }
    calculateTotal();
  }

  void addOneProduct(int index) {
    cartList[index] = cartList[index].copyWith(
      quantity: cartList[index].quantity + 1,
      totalPrice: cartList[index].totalPrice + cartList[index].unitPrice,
    );
    calculateTotal();
  }

  void saveOrder() async {
    // Prevent saving an order if the cart is empty
    if (cartList.isEmpty) {
      // If any dialog is open, ensure it is closed before showing the snackbar
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Get.snackbar(
        "سلة التسوق فارغة",
        "يرجى إضافة منتجات إلى سلة التسوق قبل إتمام الطلب.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // add progress indcator here
    Get.defaultDialog(
      title: "جاري حفظ طلبك...",
      content: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text("يرجى الانتظار..."),
        ],
      ),
    );

    MyOrder order = MyOrder(
      id: "",
      userId: "",
      customerPhone: selectedAddress.phoneNumber,
      shippingAddress: selectedAddress.addressId,
      items: cartList,
      total: total,
      status: "Pending",
      createdAt: Timestamp.now(),
      paymentStatus: "unpaid",
      customerName: "customerName",
      customerEmail: "customerEmail",
    );

    //saving order ....
    await Repo.order.addOrder(order);

    cartList.clear();
    update(); // this update is not working i dont know why?

    // close it after finishing
    Get.back();
    Get.snackbar(
      "نجاح",
      "تم حفظ طلبك بنجاح",
      snackPosition: SnackPosition.TOP,
    );
  }

  bool isRestaurantOpen(RestaurantStatus? status) {
    if (status == null) {
      return false;
    }
    if (!status.autoMode) {
      return status.isOpen;
    }
    // Auto mode: determine based on openingHours
    DateTime now = DateTime.now();
    List<String> days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    // Dart weekday: 1 Mon ... 7 Sun
    int todayIndex = now.weekday - 1; // 0..6
    int yesterdayIndex = (todayIndex - 1) < 0 ? 6 : todayIndex - 1;

    Map<String, dynamic>? getDayConfig(int index) {
      var key = days[index];
      var value = status.openingHours[key];
      if (value is Map<String, dynamic>) return value;
      if (value is Map) return Map<String, dynamic>.from(value);
      return null;
    }

    DateTime timeOnDay(DateTime baseDate, String hhmm) {
      List<String> parts = hhmm.split(':');
      int hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
      int minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
      return DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        hour,
        minute,
      );
    }

    bool isWithinWindow(
      DateTime current,
      DateTime openTime,
      DateTime closeTime,
    ) {
      if (closeTime.isBefore(openTime) ||
          closeTime.isAtSameMomentAs(openTime)) {
        // Overnight: close on next day
        closeTime = closeTime.add(const Duration(days: 1));
        if (current.isBefore(openTime)) {
          // If current after midnight but before openTime same-day, interpret current as next day
          current = current.add(const Duration(days: 1));
        }
      }
      return (current.isAtSameMomentAs(openTime) ||
              current.isAfter(openTime)) &&
          current.isBefore(closeTime);
    }

    // Check today's window
    var todayCfg = getDayConfig(todayIndex);
    if (todayCfg != null && (todayCfg['enabled'] ?? false) == true) {
      String openStr = (todayCfg['open'] ?? '00:00').toString();
      String closeStr = (todayCfg['close'] ?? '00:00').toString();
      DateTime openTime = timeOnDay(now, openStr);
      DateTime closeTime = timeOnDay(now, closeStr);
      if (isWithinWindow(now, openTime, closeTime)) {
        return true;
      }
    }

    // Also check if yesterday had an overnight window spilling into today
    var yCfg = getDayConfig(yesterdayIndex);
    if (yCfg != null && (yCfg['enabled'] ?? false) == true) {
      String openStr = (yCfg['open'] ?? '00:00').toString();
      String closeStr = (yCfg['close'] ?? '00:00').toString();
      DateTime yDate = now.subtract(const Duration(days: 1));
      DateTime openTime = timeOnDay(yDate, openStr);
      DateTime closeTime = timeOnDay(yDate, closeStr);
      if (closeTime.isBefore(openTime) ||
          closeTime.isAtSameMomentAs(openTime)) {
        if (isWithinWindow(now, openTime, closeTime)) {
          return true;
        }
      }
    }

    return false;
  }

  void placeOrder() async {
    // Do not proceed if cart is empty
    if (cartList.isEmpty) {
      Get.snackbar(
        "سلة التسوق فارغة",
        "يرجى إضافة منتجات إلى سلة التسوق قبل إتمام الطلب.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // add progress indcator here
    Get.defaultDialog(
      title: "جاري حفظ طلبك...",
      content: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text("جاري التحميل..."),
        ],
      ),
    );
    List<Address> addresses = await Repo.address.getAddresses(
      Repo.auth.getCurrentUser()!.uid,
    );
    RestaurantStatus? status = await Repo().fetchRestaurantStatus();
    if (addresses.isEmpty) {
      Get.back(); // close previous dialog/page if open
      Get.defaultDialog(
        title: "خطأ",
        middleText: "يرجى إضافة عنوانك أولاً",
        textConfirm: "حسناً",
        onConfirm: () {
          Get.back(); // close the dialog
          Get.to(() => AddressScreen()); // navigate after closing
        },
      );
    } else if (selectedAddress.latitude == 0) {
      Get.back();
      Get.defaultDialog(
        title: "خطأ",
        middleText: "يرجى اختيار عنوانك أولاً",
        textConfirm: "حسناً",
        onConfirm: () {
          Get.back(); // close the dialog only
        },
      );
    } else if (!isRestaurantOpen(status)) {
      Get.back();
      Get.defaultDialog(
        title: "خطأ",
        middleText: status?.closedMessage ?? "المطعم مغلق",
        textConfirm: "حسناً",
        onConfirm: () {
          Get.back(); // close the dialog
        },
      );
    } else {
      Get.back();
      Get.defaultDialog(
        title: "تأكيد عنوانك",
        content: Column(
          children: [
            const SizedBox(height: 20),
            Text(selectedAddress.address),
            const SizedBox(height: 20),
            Text(selectedAddress.phoneNumber),
            const SizedBox(height: 20),
          ],
        ),
        onConfirm: () {
          Get.back();
          saveOrder();
        },
        textConfirm: "تأكيد",
        onCancel: () {
          Get.back();
        },
      );
    }
  }

  void selectAddress(addressTapped) {
    selectedAddress = addressTapped;
    update();
  }
}
