import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/routes/routes.dart';
import 'package:siscoca/app/modules/categories/index.dart';
import '../../main/main_screen.dart';

class CategoriesCreateView extends GetView<CategoriesCreateController> {
  const CategoriesCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => MainScreen(
          title: controller.isEdit.value ? 'Editar Categoría' : 'Nueva Categoría',
          routes: controller.isEdit.value ? 
            [
              {'label': 'Categorias', 'path': AppRoutes.categories},
              {'label': 'Editar', 'path': AppRoutes.categoriesCreate}
            ] : 
            [
              {'label': 'Categorias', 'path': AppRoutes.categories},
              {'label': 'Crear', 'path': AppRoutes.categoriesCreate}
            ],
          loader: controller.brain.dataStatus.value,
          desktop: const CategoriesCreateDesktopView(),
          mobile: const CategoriesCreateDesktopView(),
          tablet: const CategoriesCreateDesktopView(),
        ));
  }
}
