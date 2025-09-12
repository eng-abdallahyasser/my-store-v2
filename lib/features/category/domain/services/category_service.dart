import 'package:store_app_v2/data/model/category.dart';
import 'package:store_app_v2/features/category/domain/repositories/category_repository_interface.dart';
import 'package:store_app_v2/features/category/domain/services/category_service_interface.dart';

class CategoryService implements CategoryServiceInterface {
  final CategoryRepositoryInterface repository;
  CategoryService({required this.repository});

  @override
  Future<List<Category>> getCategories() async {
    return await repository.getCategories();
  }
}
