import 'package:api/api.dart';
import 'package:domain/domain.dart';

/// Service class responsible for handling article-related operations
/// Manages CRUD operations for articles through API communication
class ArticleService {

  Future<List<Article>> getArticles() async {
    try {
      final (data, error) = await NewsApi.getNews();
      
      if (error.isNotEmpty) {
        throw ArticleException('Failed to fetch articles: $error');
      }
      
      return data?.map((json) => Article.fromJson(json)).toList() ?? [];
    } catch (e) {
      throw ArticleException('Error fetching articles: $e');
    }
  }

  Future<Article> createArticle(Article article) async {
    try {
      final (data, error) = await NewsApi.postArticle(article.toJson());
      
      if (error.isNotEmpty) {
        throw ArticleException('Failed to create article: $error');
      }
      
      return Article.fromJson(data!);
    } catch (e) {
      throw ArticleException('Error creating article: $e');
    }
  }

  Future<Article> updateArticle(int id, Article article) async {
    try {
      final (data, error) = await NewsApi.putArticle(id, article.toJson());
      
      if (error.isNotEmpty) {
        throw ArticleException('Failed to update article: $error');
      }
      
      return Article.fromJson(data!);
    } catch (e) {
      throw ArticleException('Error updating article: $e');
    }
  }

  Future<void> deleteArticle(int id) async {
    try {
      final error = await NewsApi.deleteArticle(id);
      
      if (error.isNotEmpty) {
        throw ArticleException('Failed to delete article: $error');
      }
    } catch (e) {
      throw ArticleException('Error deleting article: $e');
    }
  }
}

class ArticleException implements Exception {
  final String message;
  
  ArticleException(this.message);
  
  @override
  String toString() => 'ArticleException: $message';
}