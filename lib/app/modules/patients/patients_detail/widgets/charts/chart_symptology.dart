import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:siscoca/app/modules/patients/patients_detail/controllers/patients_detail_controller.dart';
import 'package:siscoca/app/modules/patients/patients_detail/widgets/charts/date_range.dart';
import 'package:siscoca/app/modules/surveys/surveys_response/layout/survey_responses.dart';
import '../../../../../widgets/list/list_table.dart';

class SymptomatologyList extends GetView<PatientsDetailController> {
  const SymptomatologyList({super.key});

  Widget _buildSymptomInfo(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.medical_information,
          color: Colors.blue,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          '${index + 1}.',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Cuestionario',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Rx<int> selectedDays = 30.obs;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Título y selector de fechas
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Registro de Sintomatología',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: DateRangeDropdown(
                    selectedDays: selectedDays.value,
                    onDaysChanged: (value) {
                      selectedDays.value = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Contenido
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double availableWidth = constraints.maxWidth;
                final double symptomWidth = availableWidth * 0.5;
                final double dateWidth = availableWidth * 0.3;
                final double actionWidth = availableWidth * 0.2;

                return Obx(() {
                  final symptomsData = controller.healthDataPoints
                      .where((point) => point.type == HealthDataType.SYMPTOM)
                      .where((point) {
                        final daysAgo = DateTime.now().difference(point.dateFrom).inDays;
                        return daysAgo <= selectedDays.value;
                      })
                      .toList();

                  if (symptomsData.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medical_information_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay registros de sintomatología disponibles',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListTableWidget(
                    isPaginated: false,
                    headers: [
                      TableHeader(title: 'Sintomatología', width: symptomWidth),
                      TableHeader(title: 'Fecha', width: dateWidth),
                      TableHeader(title: 'Detalle', width: actionWidth),
                    ],
                    rows: symptomsData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final symptom = entry.value;
                      final date = symptom.dateFrom;
                      final formattedDate = DateFormat('dd/MM/yyyy').format(date);

                      return TableRowData(
                        cells: [
                          _buildSymptomInfo(index),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_red_eye_rounded,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => SurveyResponseDesktop(
                                  value: symptom.value
                                )
                              );
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}