import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;
  
  // Listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Get current user ID
  String? get userId => user?.uid;
  
  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        // User is signed out
      } else {
        // User is signed in
      }
    });
  }
  
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
