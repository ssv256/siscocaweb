
import 'package:domain/models/news/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/categories/index.dart';
import 'package:siscoca/app/widgets/buttons/ed_icon_button.dart';
import 'package:siscoca/app/widgets/card/v1/card/main_card.dart';
import 'package:siscoca/app/widgets/image/single_image_icon.dart';
import 'package:siscoca/app/widgets/list/list_table.dart';

class CategoriesDesktopView extends GetView<CategoriesController> {
  const CategoriesDesktopView({super.key});

    @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          const FilterCategories(),
          const SizedBox(height: 10),
          MainCard(
            height: MediaQuery.of(context).size.height - 225,
            margin: EdgeInsets.zero,
            child: Obx(() {
              return ListTableWidget(
                headers: [
                  TableHeader(title: 'Image', width: 80),
                  TableHeader(title: 'Title', width: 300),
                  TableHeader(title: 'Description', width: 400),
                  TableHeader(title: 'Actions', width: 200),
                ],
                rows: controller.categoriesFiltered.map<TableRowData>((category) {
                  return TableRowData(
                    onTap: () => Get.offNamed('/categories/detail'),
                    cells: [
                      Container(
                        width: 50,
                        alignment: Alignment.centerLeft,
                        child: SingleImageIcon(
                          photo: category.urlToImage,
                        )
                      ),
                      Text(
                        category.category,
                        style: const TextStyle(color: Colors.black, fontSize: 14)
                      ),
                      Text(
                        category.description,
                        style: const TextStyle(color: Colors.black, fontSize: 14)
                      ),
                      Row(
                        children: [
                          EdIconBtn(
                            color: Colors.green,
                            bg: true,
                            icon: Icons.edit,
                            onTap: () => Get.offNamed(
                              '/categories/create',
                              arguments: category
                            )
                          ),
                          const SizedBox(width: 10),
                          EdIconBtn(
                            color: Colors.red,
                            bg: true,
                            icon: Icons.delete,
                            onTap: () => _showDeleteDialog(context, category)
                          )
                        ]
                      )
                    ]
                  );
                }).toList(),
              );
            })
          )
        ]
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, NewsCategory category) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.category}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')
          ),
          TextButton(
            onPressed: () {
              controller.removeData(category.id!);
              Navigator.of(context).pop();
            },
            child: const Text('Confirm')
          )
        ]
      )
    );
  }
}
