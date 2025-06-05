import 'package:api/api.dart';
import 'package:domain/models/news/models/category.dart';

class NewsCategoriesService {
  Future<List<NewsCategory>> getCategories() async {
    try {
      final (data, error) = await NewsCategoriesApi.getCategories();
      if (error.isNotEmpty) {
        throw CategoryException('Failed to fetch categories: $error');
      }
      return data?.map((json) => NewsCategory.fromJson(json)).toList() ?? [];
    } catch (e) {
      throw CategoryException('Error fetching categories: $e');
    }
  }

  Future<NewsCategory> createCategory(NewsCategory category) async {
    try {
      final (data, error) = await NewsCategoriesApi.postCategory(category.toJson());
      if (error.isNotEmpty) {
        throw CategoryException('Failed to create category: $error');
      }
      return NewsCategory.fromJson(data!);
    } catch (e) {
      throw CategoryException('Error creating category: $e');
    }
  }

  Future<NewsCategory> updateCategory(int id, NewsCategory category) async {
    try {
      final (data, error) = await NewsCategoriesApi.putCategory(id, category.toJson());
      if (error.isNotEmpty) {
        throw CategoryException('Failed to update category: $error');
      }
      return NewsCategory.fromJson(data!);
    } catch (e) {
      throw CategoryException('Error updating category: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final error = await NewsCategoriesApi.deleteCategory(id);
      if (error.isNotEmpty) {
        throw CategoryException('Failed to delete category: $error');
      }
    } catch (e) {
      throw CategoryException('Error deleting category: $e');
    }
  }
}

class CategoryException implements Exception {
  final String message;
  CategoryException(this.message);

  @override
  String toString() => 'CategoryException: $message';
}
