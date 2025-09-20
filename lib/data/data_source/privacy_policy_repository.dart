import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/model/privacy_policy.dart';

class PrivacyPolicyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collection = 'app_config';
  static const String docId = 'privacy_policy';

  Future<PrivacyPolicy?> getLatest() async {
    final doc = await _firestore.collection(collection).doc(docId).get();
    if (!doc.exists) return null;
    return PrivacyPolicy.fromFirestore(doc);
  }

  Stream<PrivacyPolicy?> latestStream() {
    return _firestore.collection(collection).doc(docId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return PrivacyPolicy.fromFirestore(doc);
    });
  }

  Future<void> upsert({
    required String title,
    required String content,
  }) async {
    await _firestore.collection(collection).doc(docId).set({
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
