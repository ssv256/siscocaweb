import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/surveys/surveys_response/controller/survey_response_controller.dart';
import 'package:siscoca/app/widgets/list/list_table.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'survey_responses.dart';

class SurveyRespondeListDesktop extends GetView<SurveyResponseController> {
  const SurveyRespondeListDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get available width from parent
        final double availableWidth = constraints.maxWidth;
        final double nameWidth = availableWidth * 0.2;
        final double descriptionWidth = availableWidth * 0.5;
        final double completedWidth = availableWidth * 0.15; 
        final double actionWidth = availableWidth * 0.15; 

        return Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if there are no survey responses
          if (controller.surveysResponse.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.clipboard_text,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No survey responses available',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This patient has not completed any surveys yet',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListTableWidget(
            isPaginated: false,
            headers: [
              TableHeader(title: 'Name', width: nameWidth),
              TableHeader(title: 'Description', width: descriptionWidth),
              TableHeader(title: 'Completed', width: completedWidth),
              TableHeader(title: 'Action', width: actionWidth),
            ],
            rows: controller.surveysResponse.map((taskResponse) {
              final String completedDate = taskResponse.completedAt != null
                  ? '${taskResponse.completedAt!.day}/${taskResponse.completedAt!.month}/${taskResponse.completedAt!.year}'
                  : 'Pending';

              return TableRowData(
                onTap: () {
                  Get.offNamed('/patients/detail');
                },
                cells: [
                  Text(
                    taskResponse.task?.name ?? 'No name',
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    taskResponse.task?.description ?? 'No description',
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Center(
                    child: Text(
                      completedDate,
                      style: const TextStyle(color: Colors.black, fontSize: 14)
                    )
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.remove_red_eye_rounded,
                      color: Colors.blue
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => SurveyResponseDesktop(
                          value: taskResponse.details
                        )
                      );
                    }
                  )
                ]
              );
            }).toList(),
          );
        });
      }
    );
  }
}