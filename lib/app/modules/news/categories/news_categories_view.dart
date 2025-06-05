import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/main/main_screen.dart';
import 'package:siscoca/app/modules/news/categories/controllers/news_categories_controller.dart';
import 'package:siscoca/app/modules/news/categories/widgets/news_categories_filter.dart';
import 'package:siscoca/app/modules/news/categories/widgets/news_categories_form_dialog.dart';
import 'package:siscoca/app/modules/news/categories/widgets/news_categories_list.dart';

class NewsCategoriesView extends GetView<NewsCategoriesController> {
  const NewsCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        MainScreen(
          title: 'News Categories',
          loader: controller.brain.dataStatus.value,
          desktop: _buildDesktopView(),
          mobile: _buildDesktopView(),
          tablet: _buildDesktopView(),
          headerAction: () => controller.openCreateDialog(),
        ),
        // Overlay the form dialog
        const NewsCategoriesFormDialog(),
      ],
    ));
  }

  Widget _buildDesktopView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          // Filter section
          const NewsCategoriesFilter(),
          const SizedBox(height: 16),
          
          // Categories list
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const NewsCategoriesList(),
            ),
          ),
        ],
      ),
    );
  }
} 