import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/categories/index.dart';
import '../../main/main_screen.dart';


class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});
  @override
  Widget build(BuildContext context) {
    return  Obx(() => MainScreen(
        title       : 'Categorias',
        loader      : controller.brain.dataStatus.value,
        desktop     : const CategoriesDesktopView(),
        mobile      : const CategoriesDesktopView(),
        tablet      : const CategoriesDesktopView(),
        headerAction: (){Get.offNamed('/categories/create');},
      )
    );
  }
}
