import 'package:domain/models/news/models/article.dart';
import 'package:siscoca/app/data/services/news/article_service.dart';

class ArticleRepository {
  
  final ArticleService _service;

  ArticleRepository(this._service);

  Future<List<Article>> getArticles() => _service.getArticles();
  Future<Article> createArticle(Article article) => _service.createArticle(article);
  Future<Article> updateArticle(int id, Article article) => _service.updateArticle(id, article);
  Future<void> deleteArticle(int id) => _service.deleteArticle(id);
}