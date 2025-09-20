import 'package:cloud_firestore/cloud_firestore.dart';

class Terms {
  final String id;
  final String title;
  final String content;
  final Timestamp? updatedAt;

  Terms({
    required this.id,
    required this.title,
    required this.content,
    this.updatedAt,
  });

  factory Terms.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Terms(
      id: doc.id,
      title: (data['title'] ?? '').toString(),
      content: (data['content'] ?? '').toString(),
      updatedAt: data['updatedAt'] is Timestamp ? data['updatedAt'] as Timestamp : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
