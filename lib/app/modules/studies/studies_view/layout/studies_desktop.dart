import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:domain/domain.dart';
import 'package:siscoca/app/modules/studies/index.dart';
import 'package:siscoca/routes/routes.dart';
import '../../../../widgets/card/v1/card/main_card.dart';
import '../../../../widgets/list/list_table.dart';
import '../widget/study_filter.dart';

class StudiesDesktopView extends GetView<StudyController> {
  const StudiesDesktopView({super.key});

    @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          const FilterStudy(),
          const SizedBox(height: 10),
          Obx(() => MainCard(
            height: MediaQuery.of(context).size.height - 225,
            margin: EdgeInsets.zero,
            child: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ListTableWidget(  
                    headers: [
                      TableHeader(title: 'Titulo', width: controller.width.value / 4),
                      TableHeader(title: 'Responsable', width: controller.width.value / 4),
                      TableHeader(title: 'Hospital', width: controller.width.value / 4),
                      TableHeader(title: 'Estado', width: 100),
                    ],
                    rows: [
                      for (Study study in controller.studiesFiltered)
                        TableRowData(
                          onTap: () => Get.toNamed(
                            AppRoutes.patients,
                            arguments: study,
                          ),
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
                          ],
                        ),
                    ],
                  ),
          )),
        ],
      ),
    );
  }
}