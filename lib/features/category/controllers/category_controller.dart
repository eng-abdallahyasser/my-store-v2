import 'package:get/get.dart';
import 'package:store_app_v2/data/model/category.dart';
import 'package:store_app_v2/features/category/domain/services/category_service_interface.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryServiceInterface service;
  CategoryController({required this.service});

  var isLoading = false.obs;
  var errorMessage = RxnString();
  var categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final data = await service.getCategories();
      categories.assignAll(data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
