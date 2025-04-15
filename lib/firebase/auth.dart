import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signIn(String email, password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
      return e.code;
    }
  }

  Future<String> signUp(email, password, name) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
      return e.code;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> getCurrentUserFuture() async {
    return _auth.currentUser;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> uploadProfilePic() async {
    await _auth.currentUser!.updatePhotoURL("photoURL");
  }

  Stream<User?> getAuthState() {
    return _auth.authStateChanges();
  }
}
