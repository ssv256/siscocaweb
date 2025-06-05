import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:domain/domain.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/modules/studies_admin/index.dart';
import 'package:siscoca/routes/routes.dart';
import '../../../../widgets/buttons/ed_icon_button.dart';
import '../../../../widgets/card/v1/card/main_card.dart';
import '../../../../widgets/list/list_table.dart';
import '../widget/studies_filter_modern.dart';

class StudiesDesktopView extends GetView<StudyAdminController> {
  const StudiesDesktopView({super.key});

    @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Obx(() => Column(
        children: [
          // Using the modern filter component
          const ModernStudiesFilter(),
          const SizedBox(height: 10),
          MainCard(
            height: MediaQuery.of(context).size.height - 225,
            margin: EdgeInsets.zero,
            child: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ListTableWidget(       
                    headers: [
                      TableHeader(title: 'Titulo', width: controller.width.value / 4),
                      TableHeader(title: 'Responsable', width: controller.width.value / 4),
                      TableHeader(title: 'Hospital', width: controller.width.value / 4),
                      const TableHeader(title: 'Estado', width: 100),
                      const TableHeader(title: 'Acciones', width: 110),
                    ],
                    rows: [
                      for (Study study in controller.studiesFiltered)
                        TableRowData(
                          onTap: () => Get.toNamed('/studies/${study.id}'),
                          cells: [
                            Text(
                              study.studyName,
                              style: const TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            Text(
                              study.responsiblePerson,
                              style: const TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            Text(
                              study.hospital,
                              style: const TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: study.status == 1 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                controller.getStatusText(study.status),
                                style: TextStyle(
                                  color: study.status == 1 ? Colors.green : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                EdIconBtn(
                                  color: Colors.blue,
                                  bg: true,
                                  icon: Iconsax.edit,
                                  onTap: () => Get.toNamed(
                                    AppRoutes.studiesAdminCreate,
                                    arguments: study,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                EdIconBtn(
                                  color: Colors.red,
                                  bg: true,
                                  icon: Iconsax.trash,
                                  onTap: () => _showDeleteDialog(context, study),
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
  
  Future<void> _showDeleteDialog(BuildContext context, Study study) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Estudio'),
        content: Text('¿Está seguro de eliminar el estudio "${study.studyName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.removeData(study.id!);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}