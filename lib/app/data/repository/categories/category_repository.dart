import 'package:domain/models/news/models/category.dart';
import 'package:siscoca/app/data/services/categories/caterory_service.dart';

class CategoriesRepository {
  //todo create a Stream to getCategoies and avoid to do all times call to the
  final NewsCategoriesService _service;

  CategoriesRepository(this._service);

  Future<List<NewsCategory>> getCategories() => _service.getCategories();
  Future<NewsCategory> createCategory(NewsCategory category) => _service.createCategory(category);
  Future<NewsCategory> updateCategory(int id, NewsCategory category) => _service.updateCategory(id, category);
  Future<void> deleteCategory(int id) => _service.deleteCategory(id);
}