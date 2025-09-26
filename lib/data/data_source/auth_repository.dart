import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app_v2/data/data_source/base_repository.dart';
import 'dart:developer';

class AuthRepository extends BaseRepository {
  Future<String> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.', name: 'AuthRepository');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.', name: 'AuthRepository');
      }
      return e.code;
    }
  }

  Future<String> signUp(String email, String password, String name) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.', name: 'AuthRepository');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.', name: 'AuthRepository');
      }
      return e.code;
    } catch (e) {
      log(e.toString(), name: 'AuthRepository');
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<User?> getCurrentUserFuture() async {
    return auth.currentUser;
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Stream<User?> getAuthState() {
    return auth.authStateChanges();
  }
}