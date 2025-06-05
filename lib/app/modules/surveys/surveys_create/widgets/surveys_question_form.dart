import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:research_package/research_package.dart';
import 'package:siscoca/app/modules/surveys/index.dart';


class SurveyQuestionForm extends GetView<SurveysCreateController> {
  const SurveyQuestionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
      width: controller.brain.contentWidth.value * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                children: [
                  Text(
                    'Preguntas', 
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: Theme.of(context).colorScheme.onSurface,
                    )
                  ),
                  const Spacer(),
                  _buildActionButton(
                    context,
                    'Agregar intro',
                    Icons.info_outline,
                    Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                    () {
                      showDialog(
                        context: context,
                        builder: (context) => const SurveyInstructionModal()
                      );
                    }
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    context,
                    'Agregar pregunta',
                    Icons.add_circle_outline,
                    Theme.of(context).colorScheme.primary,
                    () {
                      showDialog(
                        context: context,
                        builder: (context) => const SurveyQuestionModal()
                      );
                    }
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.surveySelected.value.steps.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.question_answer_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No hay preguntas para mostrar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Agrega preguntas o instrucciones para crear tu cuestionario',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const SurveyQuestionModal()
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar primera pregunta'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return  ReorderableListView.builder(
                  padding: const EdgeInsets.all(8),
                  buildDefaultDragHandles: false,
                  itemCount: controller.surveySelected.value.steps.length,
                  itemBuilder: (context, index) {
                    final step = controller.surveySelected.value.steps[index];
                    return ReorderableDragStartListener(
                      key: Key('question_${step.identifier}_$index'),
                      index: index,
                      child:  SurveysQuestionCard(
                        step: step,
                        index: index,
                      ),
                    );
                  },
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    final steps = controller.surveySelected.value.steps.toList();
                    final item = steps.removeAt(oldIndex);
                    steps.insert(newIndex, item);
                    controller.surveySelected.value = RPOrderedTask(
                      identifier: controller.surveySelected.value.identifier,
                      steps: steps,
                    );
                  },
                );
            }),
          ),
        ],
      ),
    ));
  }
  
  Widget _buildActionButton(
    BuildContext context, 
    String text, 
    IconData icon, 
    Color color, 
    VoidCallback onTap
  ) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}