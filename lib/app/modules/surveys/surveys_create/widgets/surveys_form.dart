import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/widgets/buttons/status_segment_button.dart';
import '../../../../widgets/inputs/input_area.dart';
import '../../../../widgets/inputs/main_input.dart';
import '../controllers/surveys_create_controller.dart';

class SurveysForm extends GetView<SurveysCreateController> {
  const SurveysForm({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double formWidth = constraints.maxWidth;
        if (constraints.maxWidth > 600) {
          formWidth = constraints.maxWidth * 0.45;
        }
        return SizedBox(
          width: formWidth,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.document_text,
                      color: Theme.of(context).colorScheme.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Información del Cuestionario',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrollable content
              Expanded(
                child: Form(
                  key: controller.formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Iconsax.text,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFieldWidget(
                                id: 'title',
                                controller: controller.textFieldController('title'),
                                title: 'Título',
                                hintText: 'Ingrese el título del cuestionario',
                                required: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Icon(
                                Iconsax.document,
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InputAreaEd(
                                title: 'Descripción',
                                controller: controller.textFieldController('description'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Iconsax.warning_2,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFieldWidget(
                                id: 'advertencia',
                                controller: controller.textFieldController('advertencia'),
                                title: 'Advertencia',
                                hintText: 'Texto que se mostrará como advertencia al abrir el cuestionario',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        Text(
                          'Estado del Cuestionario',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() => StatusSegmentedButton(
                          label: 'Estado',
                          value: controller.status.value,
                          onChanged: controller.updateStatus,
                        )),
                        
                        const SizedBox(height: 24),
                        _buildTipsCard(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildTipsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.info_circle,
                color: Colors.amber[800],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Consejos para crear un buen cuestionario',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem(context, 'Mantén las preguntas claras y concisas'),
          _buildTipItem(context, 'Usa un lenguaje sencillo y directo'),
          _buildTipItem(context, 'Organiza las preguntas en un orden lógico'),
          _buildTipItem(context, 'Evita preguntas ambiguas o confusas'),
        ],
      ),
    );
  }
  
  Widget _buildTipItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.amber[800],
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.amber[900],
              ),
            ),
          ),
        ],
      ),
    );
  }
}