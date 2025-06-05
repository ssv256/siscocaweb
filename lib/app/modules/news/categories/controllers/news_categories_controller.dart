import 'package:domain/models/news/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/categories/category_repository.dart';
import 'package:toastification/toastification.dart';

class NewsCategoriesController extends GetxController {
  final CategoriesRepository repository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  NewsCategoriesController({required this.repository});

  // Observable properties
  final isLoading = false.obs;
  final categories = <NewsCategory>[].obs;
  final filteredCategories = <NewsCategory>[].obs;
  
  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageUrlController = TextEditingController();
  
  // Edit mode properties
  final isEditMode = false.obs;
  final currentCategory = Rxn<NewsCategory>();
  
  // Dialog visibility
  final isDialogOpen = false.obs;
  
  // Brain instance for global app state
  final Brain brain = Get.find<Brain>();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }
  
  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.onClose();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      final result = await repository.getCategories();
      categories.assignAll(result);
      filteredCategories.assignAll(result);
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
      filteredCategories.assignAll(categories);
      return;
    }

    final filtered = categories.where((category) {
      final title = category.category.toLowerCase();
      final description = category.description.toLowerCase();
      final searchValue = value.toLowerCase();
      return title.contains(searchValue) || description.contains(searchValue);
    }).toList();

    filteredCategories.assignAll(filtered);
  }
  
  void openCreateDialog() {
    resetForm();
    isEditMode.value = false;
    isDialogOpen.value = true;
  }
  
  void openEditDialog(NewsCategory category) {
    resetForm();
    titleController.text = category.category;
    descriptionController.text = category.description;
    imageUrlController.text = category.urlToImage;
    currentCategory.value = category;
    isEditMode.value = true;
    isDialogOpen.value = true;
  }
  
  void closeDialog() {
    isDialogOpen.value = false;
    resetForm();
  }
  
  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    imageUrlController.clear();
    currentCategory.value = null;
    formKey.currentState?.reset();
  }

  Future<void> saveCategory() async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      try {
        if (isEditMode.value) {
          await updateCategory();
        } else {
          await createCategory();
        }
        closeDialog();
        await loadCategories();
      } catch (e) {
        toastification.show(
          closeOnClick: true,
          icon: const Icon(Iconsax.warning_2),
          title: Text('Error: ${e.toString()}'),
          autoCloseDuration: const Duration(seconds: 2),
          style: ToastificationStyle.flat,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> createCategory() async {
    final newCategory = NewsCategory(
      category: titleController.text,
      description: descriptionController.text,
      urlToImage: imageUrlController.text,
    );

    await repository.createCategory(newCategory);
    
    toastification.show(
      closeOnClick: true,
      icon: const Icon(Iconsax.check),
      title: const Text('Category created successfully'),
      autoCloseDuration: const Duration(seconds: 2),
      style: ToastificationStyle.flat,
    );
  }

  Future<void> updateCategory() async {
    if (currentCategory.value == null || currentCategory.value!.id == null) {
      throw Exception('Cannot update category: Invalid category ID');
    }
    
    final updatedCategory = currentCategory.value!.copyWith(
      category: titleController.text,
      description: descriptionController.text,
      urlToImage: imageUrlController.text,
    );

    await repository.updateCategory(updatedCategory.id!, updatedCategory);
    
    toastification.show(
      closeOnClick: true,
      icon: const Icon(Iconsax.check),
      title: const Text('Category updated successfully'),
      autoCloseDuration: const Duration(seconds: 2),
      style: ToastificationStyle.flat,
    );
  }

  Future<void> deleteCategory(int id) async {
    isLoading.value = true;
    try {
      await repository.deleteCategory(id);
      await loadCategories();
      
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.check),
        title: const Text('Category deleted successfully'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Error deleting category: ${e.toString()}'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 