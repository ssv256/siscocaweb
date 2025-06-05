import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/categories/category_repository.dart';
import 'package:siscoca/app/data/services/categories/caterory_service.dart';
import 'package:siscoca/app/modules/categories/categories_create/controllers/categories_create_controller.dart';
import '../categories_view/controllers/categories_controller.dart';

class CategoriesBinding implements Bindings {
  @override
  void dependencies() {
    // Register service
    Get.lazyPut<NewsCategoriesService>(
      () => NewsCategoriesService(),
    );
    
    // Register repository
    Get.lazyPut<CategoriesRepository>(
      () => CategoriesRepository(Get.find<NewsCategoriesService>()),
    );
    
    // Register controller
    Get.lazyPut<CategoriesController>(
      () => CategoriesController(repository: Get.find()),
    );

    // Register create/edit controller
    Get.lazyPut<CategoriesCreateController>(
      () => CategoriesCreateController(repository: Get.find()),
    );
  }
}