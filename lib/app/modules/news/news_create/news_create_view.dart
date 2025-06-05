import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/routes/routes.dart';
import '../../main/main_screen.dart';
import 'controllers/article_create_controller.dart';
import 'layout/articles_create_desktop.dart';

class ArticlesCreateView extends GetView<ArticlesCreateController> {
  const ArticlesCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => MainScreen(
      title: controller.isEdit.value ? 'Editar Noticia' : 'Nueva Noticia',
      routes: controller.isEdit.value ? 
        [
          {'label': 'Noticias', 'path': AppRoutes.news},
          {'label': 'Editar', 'path': AppRoutes.newsCreate}
        ] : 
        [
          {'label': 'Noticias', 'path': AppRoutes.news},
          {'label': 'Crear', 'path': AppRoutes.newsCreate}
        ],
      loader: controller.brain.dataStatus.value,
      desktop: const ArticlesCreateDesktopView(),
      mobile: const ArticlesCreateDesktopView(),
      tablet: const ArticlesCreateDesktopView(),
    ));
  }
}