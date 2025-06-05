import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/categories/category_repository.dart';
import 'package:siscoca/app/data/repository/news/article_repository.dart';
import 'package:siscoca/app/data/services/categories/caterory_service.dart';
import 'package:siscoca/app/data/services/news/article_service.dart';
import 'package:siscoca/app/modules/news/index.dart';

/// Binding class responsible for dependency injection of all article-related components
/// Registers services, repositories, and controllers using GetX dependency injection
class ArticlesBinding implements Bindings {
  @override
  void dependencies() {
// Register services
    Get.lazyPut<ArticleService>(
      () => ArticleService(),
    );
    Get.lazyPut<NewsCategoriesService>(
      () => NewsCategoriesService(),
    );

    // Register repositories
    Get.lazyPut<ArticleRepository>(
      () => ArticleRepository(Get.find<ArticleService>()),
    );
    Get.lazyPut<CategoriesRepository>(
      () => CategoriesRepository(Get.find<NewsCategoriesService>()),
    );

    // Register controllers
    Get.lazyPut<ArticlesController>(
      () => ArticlesController(repository: Get.find()),
    );
    Get.lazyPut<ArticlesCreateController>(
      () => ArticlesCreateController(
        repository: Get.find(),
        categoriesRepository: Get.find(),
      ),
    );
  }
}