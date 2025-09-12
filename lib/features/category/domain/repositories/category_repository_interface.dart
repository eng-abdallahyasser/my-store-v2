import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app_v2/data/model/category.dart';

abstract class CategoryRepositoryInterface {
  final FirebaseFirestore firestore;
  const CategoryRepositoryInterface({required this.firestore});

  Future<List<Category>> getCategories();
}
