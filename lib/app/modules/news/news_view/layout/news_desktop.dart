import 'package:domain/models/news/models/article.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/news/index.dart';
import 'package:siscoca/app/widgets/buttons/ed_icon_button.dart';
import 'package:siscoca/app/widgets/card/v1/card/main_card.dart';
import 'package:siscoca/app/widgets/image/single_image_icon.dart';
import 'package:siscoca/app/widgets/list/list_table.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'dart:js' as js;

class ArticlesDesktopView extends GetView<ArticlesController> {
  const ArticlesDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          const FilterArticles(),
          const SizedBox(height: 10),
          MainCard(
            height: MediaQuery.of(context).size.height - 225,
            margin: EdgeInsets.zero,
            child: Obx(() {
              return ListTableWidget(
                headers: const [
                  TableHeader(title: 'Imagen', width: 80),
                  TableHeader(title: 'Título', width: 250),
                  TableHeader(title: 'Categoría', width: 120),
                  TableHeader(title: 'Descripción', width: 300),
                  TableHeader(title: 'Tiempo de Lectura', width: 100),
                  TableHeader(title: 'Estado', width: 80),
                  TableHeader(title: 'Acciones', width: 150),
                ],
                rows: controller.articlesFiltered.map<TableRowData>((article) {
                  return TableRowData(
                    onTap: () async {
                      final Uri url = Uri.parse(article.newsUrl);
                      // js.context.callMethod('open', ['https://stackoverflow.com/questions/ask']);
                      launchUrlWeb(url);
                    },
                    cells: [
                      Container(
                        width: 50,
                        alignment: Alignment.centerLeft,
                        child: SingleImageIcon(
                          photo: article.imageUrl,
                        ),
                      ),
                      Tooltip(
                        message: article.title,
                        child: Text(
                          article.title,
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        article.category.category,
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Tooltip(
                        message: article.description,
                        child: Text(
                          article.description,
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        controller.getReadingTimeText(article.readingTime),
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      StatusBadge(
                        isActive: article.status == 1,
                        label: controller.getStatusText(article.status!),
                      ),
                      Row(
                        children: [
                          EdIconBtn(
                            color: Colors.green,
                            bg: true,
                            icon: Icons.edit,
                            onTap: () => Get.offNamed(
                              '/news/create',
                              arguments: article,
                            ),
                          ),
                          const SizedBox(width: 10),
                          EdIconBtn(
                            color: Colors.red,
                            bg: true,
                            icon: Icons.delete,
                            onTap: () => _showDeleteDialog(context, article),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, Article article) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Article'),
        content: Text('Are you sure you want to delete "${article.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.removeData(article.id!);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final bool isActive;
  final String label;

  const StatusBadge({
    super.key,
    required this.isActive,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

Future<void> launchUrlWeb(url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}