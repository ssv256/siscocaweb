import 'package:domain/models/news/models/category.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/categories/category_repository.dart';

class CategoriesController extends GetxController {
  final CategoriesRepository repository;
  
  CategoriesController({required this.repository});

  final isLoading = false.obs;
  final width = 1000.0.obs;
  final categories = <NewsCategory>[].obs;
  final categoriesFiltered = <NewsCategory>[].obs;
  final Brain  brain = Get.find<Brain>();

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    isLoading.value = true;
    try {
      final result = await repository.getCategories();
      categories.assignAll(result);
      categoriesFiltered.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load categories: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filter(String value) {
    if (value.isEmpty) {
      categoriesFiltered.assignAll(categories);
      return;
    }

    final filtered = categories.where((category) {
    final title = category.category.toLowerCase();
    final description = category.description.toLowerCase();
    final searchValue = value.toLowerCase();
    return title.contains(searchValue) || description.contains(searchValue);
    
  }).toList();

    categoriesFiltered.assignAll(filtered);
  }

  Future<void> removeData(int id) async {
    isLoading.value = true;
    try {
      await repository.deleteCategory(id);
      await _loadCategories();
      Get.snackbar(
        'Success',
        'Category deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete category: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}