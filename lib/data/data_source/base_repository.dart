import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  
  Future<SharedPreferences> get prefs async => await SharedPreferences.getInstance();
}