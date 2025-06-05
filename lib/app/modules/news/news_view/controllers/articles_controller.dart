import 'package:domain/models/news/models/article.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/news/article_repository.dart';

class ArticlesController extends GetxController {
  final ArticleRepository repository;
  
  ArticlesController({required this.repository});

  final isLoading = false.obs;
  final width = 1000.0.obs;
  final articles = <Article>[].obs;
  final articlesFiltered = <Article>[].obs;
  
  // Category filtering properties
  final availableCategories = <String>[].obs;
  final selectedCategories = <String>[].obs;
  final isLoadingCategories = false.obs;
  
  // Status filtering properties
  final availableStatuses = <int>[].obs;
  final selectedStatuses = <int>[].obs;
  final isLoadingStatuses = false.obs;
  
  // Reading time filtering properties
  final availableReadingTimes = <int>[].obs;
  final selectedReadingTimes = <int>[].obs;
  final isLoadingReadingTimes = false.obs;
  
  // Brain instance for global app state
  final Brain brain = Get.find<Brain>();

  @override
  void onInit() {
    super.onInit();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    isLoading.value = true;
    try {
      final result = await repository.getArticles();
      articles.assignAll(result);
      articlesFiltered.assignAll(result);
      
      final Set<String> categories = {};
      final Set<int> statuses = {};
      final Set<int> readingTimes = {};
      
      for (var article in result) {
        if (article.category.category.isNotEmpty) {
          categories.add(article.category.category);
        }
        if (article.status != null) {
          statuses.add(article.status!);
        }
        readingTimes.add(article.readingTime);
      }
      
      availableCategories.assignAll(categories.toList()..sort());
      availableStatuses.assignAll(statuses.toList()..sort());
      availableReadingTimes.assignAll(readingTimes.toList()..sort());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load articles: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Filters articles based on search value and selected filters
  void filter(String value) {
    if (value.isEmpty && selectedCategories.isEmpty && selectedStatuses.isEmpty && selectedReadingTimes.isEmpty) {
      articlesFiltered.assignAll(articles);
      return;
    }

    var filtered = articles.toList();
    
    // Apply text search filter if provided
    if (value.isNotEmpty) {
      filtered = filtered.where((article) {
        final title = article.title.toLowerCase();
        final description = article.description.toLowerCase();
        final categoryName = article.category.category.toLowerCase();
        final searchValue = value.toLowerCase();

        return title.contains(searchValue) || 
               description.contains(searchValue) ||
               categoryName.contains(searchValue);
      }).toList();
    }
    
    // Apply category filter if any categories are selected
    if (selectedCategories.isNotEmpty) {
      filtered = filtered.where((article) {
        return selectedCategories.contains(article.category.category);
      }).toList();
    }
    
    // Apply status filter if any statuses are selected
    if (selectedStatuses.isNotEmpty) {
      filtered = filtered.where((article) {
        return article.status != null && selectedStatuses.contains(article.status);
      }).toList();
    }
    
    // Apply reading time filter if any reading times are selected
    if (selectedReadingTimes.isNotEmpty) {
      filtered = filtered.where((article) {
        return selectedReadingTimes.contains(article.readingTime);
      }).toList();
    }

    articlesFiltered.assignAll(filtered);
  }
  
  /// Update the selected categories list and filter articles
  void updateSelectedCategories(String category, bool isSelected) {
    if (isSelected && !selectedCategories.contains(category)) {
      selectedCategories.add(category);
    } else if (!isSelected && selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    }
    filter(''); // Reapply filters with current text filter
  }
  
  /// Update the selected statuses list and filter articles
  void updateSelectedStatuses(int status, bool isSelected) {
    if (isSelected && !selectedStatuses.contains(status)) {
      selectedStatuses.add(status);
    } else if (!isSelected && selectedStatuses.contains(status)) {
      selectedStatuses.remove(status);
    }
    filter(''); // Reapply filters with current text filter
  }
  
  /// Update the selected reading times list and filter articles
  void updateSelectedReadingTimes(int readingTime, bool isSelected) {
    if (isSelected && !selectedReadingTimes.contains(readingTime)) {
      selectedReadingTimes.add(readingTime);
    } else if (!isSelected && selectedReadingTimes.contains(readingTime)) {
      selectedReadingTimes.remove(readingTime);
    }
    filter(''); // Reapply filters with current text filter
  }
  
  /// Reset category filters
  void resetCategoryFilters() {
    selectedCategories.clear();
    filter(''); // Reapply any text filter that might be active
  }
  
  /// Reset status filters
  void resetStatusFilters() {
    selectedStatuses.clear();
    filter(''); // Reapply any text filter that might be active
  }
  
  /// Reset reading time filters
  void resetReadingTimeFilters() {
    selectedReadingTimes.clear();
    filter(''); // Reapply any text filter that might be active
  }
  
  /// Reset all filters
  void resetAllFilters() {
    selectedCategories.clear();
    selectedStatuses.clear();
    selectedReadingTimes.clear();
    filter(''); // Reapply any text filter that might be active
  }

  /// Removes an article by ID
  Future<void> removeData(int id) async {
    isLoading.value = true;
    try {
      await repository.deleteArticle(id);
      await _loadArticles();
      Get.snackbar(
        'Success',
        'Article deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete article: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper method to get reading time in human readable format
  String getReadingTimeText(int minutes) {
    if (minutes < 1) return 'Less than a minute';
    if (minutes == 1) return '1 minute';
    return '$minutes minutes';
  }

  /// Helper method to format date strings
  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Helper method to get article status text
  String getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Active';
      case 0:
        return 'Inactive';
      default:
        return 'Unknown';
    }
  }
}