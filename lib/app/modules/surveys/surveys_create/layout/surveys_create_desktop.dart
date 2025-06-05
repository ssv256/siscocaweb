import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/card/v1/card/main_card.dart';
import '../controllers/surveys_create_controller.dart';
import '../widgets/surveys_form.dart';
import '../widgets/surveys_question_form.dart';

class SurveysCreateDesktopView extends GetView<SurveysCreateController> {
  const SurveysCreateDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          final isTablet = constraints.maxWidth >= 768 && constraints.maxWidth < 1024;
          
          return Obx(() => MainCard(
            width: MediaQuery.of(context).size.width - 30,
            height: MediaQuery.of(context).size.height - 150,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: controller.isLoading.value
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando...', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: _buildFormLayout(context, isMobile, isTablet),
                      ),
                      const SizedBox(height: 16),
                      _buildFooter(context),
                    ],
                  ),
            ),
          ));
        },
      ),
    );
  }

  Widget _buildFormLayout(BuildContext context, bool isMobile, bool isTablet) {
    if (isMobile) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SurveysForm(),
              SizedBox(height: 24),
              Divider(height: 32),
              SizedBox(height: 8),
              SurveyQuestionForm(),
            ],
          ),
        ),
      );
    } else if (isTablet) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        padding: const EdgeInsets.all(16),
        child: const SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: SurveysForm()),
              SizedBox(width: 24),
              VerticalDivider(thickness: 1),
              SizedBox(width: 24),
              Expanded(child: SurveyQuestionForm()),
            ],
          ),
        ),
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 2,
            child: SurveysForm(),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: const VerticalDivider(thickness: 1),
          ),
          const Expanded(
            flex: 3,
            child: SurveyQuestionForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Cancelar'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              if (controller.formKey.currentState!.validate() && 
                  controller.surveySelected.value.steps.isNotEmpty) {
                controller.createOrUpdateSurvey();
              } else {
                Get.snackbar(
                  'Error',
                  'Por favor completa todos los campos requeridos y agrega al menos una pregunta',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 8,
                  duration: const Duration(seconds: 3),
                );
              }
            },
            icon: const Icon(Icons.save),
            label: const Text('Guardar Cuestionario'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Show preview dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Vista Previa'),
                  content: const Text('Esta funcionalidad estará disponible próximamente.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.visibility),
            label: const Text('Vista Previa'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}