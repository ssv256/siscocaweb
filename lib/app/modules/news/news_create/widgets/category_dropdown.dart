import 'package:flutter/material.dart';
import 'package:domain/models/news/models/category.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/news/index.dart';

class CategoryDropdown extends GetView<ArticlesCreateController> {
  final NewsCategory? selectedCategory;
  final ValueChanged<NewsCategory?> onChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Obx(() => DropdownButtonFormField<NewsCategory>(
            value: selectedCategory,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              border: InputBorder.none,
            ),
            hint: const Text('Select Category'),
            items: controller.categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.category),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null) {
                return 'Please select a category';
              }
              return null;
            },
          )),
        ),
      ],
    );
  }
}