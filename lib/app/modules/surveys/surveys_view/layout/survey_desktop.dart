import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:domain/domain.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/routes/routes.dart';
import '../../../../widgets/buttons/ed_icon_button.dart';
import '../../../../widgets/card/v1/card/main_card.dart';
import '../../../../widgets/list/list_table.dart';
import '../controllers/survey_controller.dart';
import '../widget/filter_surveys.dart';

class SurveyDesktopView extends GetView<SurveyController> {
  const SurveyDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Obx(() => Column(
        children: [
          // Replace the simple search field with the new filter widget
          const FilterSurveys(),
          const SizedBox(height: 10),
          MainCard(
            height: MediaQuery.of(context).size.height - 225,
            margin: EdgeInsets.zero,
            child: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ListTableWidget(
                    
                    headers: const [
                      TableHeader(title: '#', width: 60),
                      TableHeader(title: 'Nombre', width: 200),
                      TableHeader(title: 'Descripción', width: 300),
                      TableHeader(title: 'Preguntas', width: 100),
                      TableHeader(title: 'F. Creación', width: 120),
                      TableHeader(title: 'Estado', width: 100),
                      TableHeader(title: 'Acciones', width: 110),
                    ],
                    rows: [
                      for (int index = 0; index < controller.surveysFiltered.length; index++)
                        TableRowData(
                          // onTap: () => Get.toNamed(AppRoutes.surveyCreate, arguments: {'task': controller.surveysFiltered[index]}),
                          cells: [
                            // Number column
                            Center(
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Name column
                            Text(
                              controller.surveysFiltered[index].name,
                              style: const TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            // Description column
                            Text(
                              controller.surveysFiltered[index].description,
                              style: const TextStyle(color: Colors.black, fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Questions count column
                            Center(
                              child: Text(
                                controller.getQuestionCount(controller.surveysFiltered[index]).toString(),
                                style: const TextStyle(color: Colors.black, fontSize: 14),
                              ),
                            ),
                            // Creation date column
                            Center(
                              child: Text(
                                controller.formatDate(controller.surveysFiltered[index].createdAt!),
                                style: const TextStyle(color: Colors.black, fontSize: 14),
                              ),
                            ),
                            // Status column
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: controller.surveysFiltered[index].status == 1 
                                  ? Colors.green.withOpacity(0.1) 
                                  : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                controller.getStatusText(controller.surveysFiltered[index].status!),
                                style: TextStyle(
                                  color: controller.surveysFiltered[index].status == 1 ? Colors.green : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            // Actions column
                            Row(
                              children: [
                                EdIconBtn(
                                  color: Colors.blue,
                                  bg: true,
                                  icon: Iconsax.edit,
                                  onTap: () => Get.toNamed(AppRoutes.surveyCreate, arguments: {'task': controller.surveysFiltered[index]})
                                ),
                                const SizedBox(width: 10),
                                EdIconBtn(
                                  color: Colors.red,
                                  bg: true,
                                  icon: Iconsax.trash,
                                  onTap: () => _showDeleteDialog(context, controller.surveysFiltered[index]),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
          ),
        ],
      )),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, Task survey) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Encuesta'),
        content: Text('¿Está seguro de eliminar la encuesta "${survey.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.desactivateTask(survey.id!);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            child: const Text('Desactivar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.removeData(survey.id!);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}