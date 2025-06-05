import 'package:domain/models/news/models/article.dart';
import 'package:domain/models/news/models/category.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/categories/category_repository.dart';
import 'package:siscoca/app/data/repository/news/article_repository.dart';
import 'package:toastification/toastification.dart';

class ArticlesCreateController extends GetxController {
  final ArticleRepository repository;
  final CategoriesRepository categoriesRepository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  final RxBool isEdit = false.obs;
  final Rxn<Article> currentArticle = Rxn<Article>();
  final RxList<NewsCategory> categories = <NewsCategory>[].obs;

 
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController imageUrlController;
  late final TextEditingController newsUrlController;
  late final TextEditingController readingTimeController;
  
  // Additional controllers for article-specific fields
  final Rx<NewsCategory?> selectedCategory = Rx<NewsCategory?>(null);
  final RxInt status = 1.obs;
  final Brain brain = Get.find<Brain>();

  ArticlesCreateController({
    required this.repository,
    required this.categoriesRepository,
    Article? article,
  }) {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    imageUrlController = TextEditingController();
    newsUrlController = TextEditingController();
    readingTimeController = TextEditingController();
    
    if (article != null) {
      _initializeWithArticle(article);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
    checkForArticle();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    newsUrlController.dispose();
    readingTimeController.dispose();
    super.onClose();
  }

  Future<void> _loadCategories() async {
    try {
      final result = await categoriesRepository.getCategories();
      categories.assignAll(result);
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Error loading categories: ${e.toString()}'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    }
  }
  void _initializeWithArticle(Article article) {
    titleController.text = article.title;
    descriptionController.text = article.description;
    imageUrlController.text = article.imageUrl;
    newsUrlController.text = article.newsUrl;
    readingTimeController.text = article.readingTime.toString();
    selectedCategory.value = article.category;
    status.value = article.status!;
    currentArticle.value = article;
    isEdit.value = true;
  }

  void checkForArticle() async {
    isLoading.value = true;
    try {
      final dynamic arguments = Get.arguments;
      if (arguments is Article) {
        _initializeWithArticle(arguments);
      } else {
        isEdit.value = false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load article: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateCategory(NewsCategory? category) {
    selectedCategory.value = category;
  }

  void updateStatus(int newStatus) {
    status.value = newStatus;
  }

  Future<void> create() async {
    if (selectedCategory.value == null) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: const Text('Please select a category'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
      return;
    }

    try {
      final newArticle = Article(
        title: titleController.text,
        description: descriptionController.text,
        imageUrl: imageUrlController.text,
        newsUrl: newsUrlController.text,
        readingTime: int.tryParse(readingTimeController.text) ?? 1,
        categoryId: selectedCategory.value!.id!,
        category: selectedCategory.value!,
        status: status.value,
      );

      await repository.createArticle(newArticle);

      Get.offNamed('/news');
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.check),
        title: const Text('Article created successfully'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Error creating article: ${e.toString()}'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateData() async {
    if (selectedCategory.value == null) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: const Text('Please select a category'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
      return;
    }

    try {
      final updatedArticle = currentArticle.value!.copyWith(
        title: titleController.text,
        description: descriptionController.text,
        imageUrl: imageUrlController.text,
        newsUrl: newsUrlController.text,
        readingTime: int.tryParse(readingTimeController.text) ?? 1,
        categoryId: selectedCategory.value!.id!,
        category: selectedCategory.value!,
        status: status.value,
        dateUpdate: DateTime.now().toIso8601String(),
      );

      await repository.updateArticle(updatedArticle.id!, updatedArticle);
      
      Get.offNamed('/news');
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.check),
        title: const Text('Article updated successfully'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Error updating article: ${e.toString()}'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void checkForm() {
    if (formKey.currentState?.validate() ?? false) {
      if (isEdit.value) {
        updateData();
      } else {
        create();
      }
    }
  }

  String? validateReadingTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Reading time is required';
    }
    final number = int.tryParse(value);
    if (number == null || number < 1) {
      return 'Please enter a valid reading time';
    }
    return null;
  }
}