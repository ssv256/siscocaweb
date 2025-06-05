import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/categories/category_repository.dart';
import 'package:siscoca/app/data/services/categories/caterory_service.dart';
import 'package:siscoca/app/modules/news/categories/controllers/news_categories_controller.dart';

class NewsCategoriesBinding implements Bindings {
  @override
  void dependencies() {
    // Register service if not already registered
    if (!Get.isRegistered<NewsCategoriesService>()) {
      Get.lazyPut<NewsCategoriesService>(
        () => NewsCategoriesService(),
      );
    }
    
    // Register repository if not already registered
    if (!Get.isRegistered<CategoriesRepository>()) {
      Get.lazyPut<CategoriesRepository>(
        () => CategoriesRepository(Get.find<NewsCategoriesService>()),
      );
    }
    
    // Register controller
    Get.lazyPut<NewsCategoriesController>(
      () => NewsCategoriesController(repository: Get.find()),
    );
  }
} 