import 'package:store_app_v2/data/model/category.dart';

abstract class CategoryServiceInterface {
  Future<List<Category>> getCategories();
}
