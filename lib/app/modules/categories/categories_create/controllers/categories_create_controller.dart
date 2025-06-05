import 'package:domain/models/news/models/category.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/categories/category_repository.dart';
import 'package:toastification/toastification.dart';

class CategoriesCreateController extends GetxController {
  final CategoriesRepository repository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  final RxBool isEdit = false.obs;
  final Rxn<NewsCategory> currentCategory = Rxn<NewsCategory>();
  final Brain brain = Get.find<Brain>();

  // Typed text controllers
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController imageController;

  CategoriesCreateController({
    required this.repository,
    NewsCategory? category,
  }) {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    imageController = TextEditingController();
    
    if (category != null) {
      _initializeWithCategory(category);
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkForCategory();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    super.onClose();
  }

  void _initializeWithCategory(NewsCategory category) {
    titleController.text = category.category;
    descriptionController.text = category.description;
    imageController.text = category.urlToImage;
    currentCategory.value = category;
    isEdit.value = true;
  }

  void checkForCategory() async {
    isLoading.value = true;
    try {
      final dynamic arguments = Get.arguments;
      if (arguments is NewsCategory) {
        _initializeWithCategory(arguments);
      } else {
        isEdit.value = false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load category: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> create() async {
    try {
      final newCategory = NewsCategory(
        category: titleController.text,
        description: descriptionController.text,
        urlToImage: imageController.text,
      );

      await repository.createCategory(newCategory);

      Get.offNamed('/categories');
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.check),
        title: const Text('Dato creado correctamente'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Error al crear: ${e.toString()}'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateData() async {
    try {
      final updatedCategory = currentCategory.value!.copyWith(
        category: titleController.text,
        description: descriptionController.text,
        urlToImage: imageController.text,
      );

      await repository.updateCategory(updatedCategory.id!, updatedCategory);
      
      Get.offNamed('/categories');
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.check),
        title: const Text('Datos actualizados correctamente'),
        autoCloseDuration: const Duration(seconds: 2),
        style: ToastificationStyle.flat,
      );
    } catch (e) {
      toastification.show(
        closeOnClick: true,
        icon: const Icon(Iconsax.warning_2),
        title: Text('Error al actualizar: ${e.toString()}'),
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
}