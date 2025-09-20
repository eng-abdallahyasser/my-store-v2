import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/model/terms.dart';

class TermsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collection = 'app_config';
  static const String docId = 'terms';

  Future<Terms?> getLatestTerms() async {
    final doc = await _firestore.collection(collection).doc(docId).get();
    if (!doc.exists) return null;
    return Terms.fromFirestore(doc);
  }

  Stream<Terms?> latestTermsStream() {
    return _firestore.collection(collection).doc(docId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Terms.fromFirestore(doc);
    });
  }

  Future<void> upsertTerms({
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
