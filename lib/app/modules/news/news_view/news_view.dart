import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/news/index.dart';
import 'package:siscoca/routes/routes.dart';
import '../../main/main_screen.dart';

class NewsView extends GetView<ArticlesController> {
  const NewsView({super.key});
  
  static const List<Map<String, String>> _routes = [
    {'label': 'Categorías', 'path': AppRoutes.newsCategories},
  ];
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => MainScreen(
        title: 'Noticias',
        loader: controller.brain.dataStatus.value,
        desktop: const ArticlesDesktopView(),
        mobile: const ArticlesDesktopView(),
        tablet: const ArticlesDesktopView(),
        headerAction: () {Get.offNamed('/news/create');},
        routes: _routes,
      )
    );
  }
}
