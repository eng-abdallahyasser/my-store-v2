import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/model/category.dart';
import 'package:store_app_v2/features/category/domain/repositories/category_repository_interface.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  @override
  final FirebaseFirestore firestore;
  CategoryRepository({required this.firestore});

  @override
  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await firestore.collection('categories').get();
      return snapshot.docs
          .map((doc) => Category.fromMap(doc.data()))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
