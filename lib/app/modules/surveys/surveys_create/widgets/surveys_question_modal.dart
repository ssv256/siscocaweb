import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/app/modules/surveys/surveys_create/controllers/ext_survey_create_controller.dart';

import '../../../../widgets/buttons/ed_button.dart';
import '../../../../widgets/inputs/input_area.dart';
import '../../../../widgets/inputs/main_input.dart';
import '../controllers/surveys_create_controller.dart';

class SurveyQuestionModal extends GetView<SurveysCreateController> {
  
  const SurveyQuestionModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Initialize the form when opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.stepToEdit.value == null) {
        // Only initialize if creating a new question, not editing
        controller.initNewQuestion();
      }
    });
    
    return Obx(() => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  controller.stepToEdit.value != null ? Iconsax.edit : Iconsax.add_circle,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  controller.stepToEdit.value != null ? 'Editar pregunta' : 'Nueva pregunta',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                EdButton(
                  textColor: Colors.white,
                  bgColor: Colors.red[400],
                  text: 'Cancelar',
                  onTap: () {
                    controller.clearEditMode();
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 12),
                EdButton(
                  textColor: Colors.white,
                  bgColor: theme.colorScheme.primary,
                  text: 'Guardar',
                  onTap: () async {
                    controller.saveQuestion();
                    controller.clearEditMode();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    // Question text
                    _buildSectionHeader(context, 'Pregunta', Iconsax.message_question),
                    const SizedBox(height: 12),
                    InputAreaEd(
                      title: 'Escribe tu pregunta',
                      controller: controller.textFieldController('questionQuestion'),
                    ),
                    const SizedBox(height: 24),
                    
                    // Question type
                    _buildSectionHeader(context, 'Tipo de respuesta', Iconsax.format_square),
                    const SizedBox(height: 12),
                    _buildQuestionTypeSelector(context),
                    const SizedBox(height: 24),
                    
                    // Question options
                    _buildSectionHeader(context, 'Configuración de respuesta', Iconsax.setting_2),
                    const SizedBox(height: 16),
                    buildQuestionOptions(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
  
  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuestionTypeSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona el tipo de respuesta que esperas de tus encuestados',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTypeOption(
                  context, 
                  'Radio', 
                  'Opciones de selección única o múltiple',
                  Iconsax.radio,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeOption(
                  context, 
                  'Slider', 
                  'Escala deslizante con valores mínimos y máximos',
                  Iconsax.slider_horizontal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTypeOption(
                  context, 
                  'Numeros', 
                  'Entrada numérica con límites',
                  Iconsax.calculator,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeOption(
                  context, 
                  'Text', 
                  'Respuesta de texto libre',
                  Iconsax.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTypeOption(BuildContext context, String type, String description, IconData icon) {
    final isSelected = controller.questionType.value == type;
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () => controller.questionType.value = type,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? theme.colorScheme.primary : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  type,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? theme.colorScheme.primary : Colors.black87,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget ratioQuestion(context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Multiple choice toggle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.tick_square,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Permitir selección múltiple',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Obx(() => Switch(
                  value: controller.isMultipleChoice.value,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (v) => controller.isMultipleChoice.value = v,
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          Text(
            'Opciones de respuesta',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          
          // Options list
          Obx(() => Column(
            children: [
              for (var option in controller.questionOptions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: radioInput(context, option),
                ),
            ],
          )),
          
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => controller.addQuestionOption(),
              icon: const Icon(Iconsax.add_circle),
              label: const Text('Agregar opción'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget radioInput(context, Map<String, dynamic> option) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            controller.isMultipleChoice.value ? Iconsax.tick_square : Iconsax.radio,
            color: theme.colorScheme.primary.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFieldWidget(
              hintText: 'Escribe una opción de respuesta',
              controller: controller.textFieldController('option${option['id']}'),
              required: true,
            )
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Iconsax.trash, size: 20),
            color: Colors.red[400],
            onPressed: () => controller.removeQuestionOption(option['id']),
            tooltip: 'Eliminar opción',
          ),
        ],
      ),
    );
  }
  
  Widget buildQuestionOptions(BuildContext context) {
    return Obx(() {
      switch (controller.questionType.value) {
        case 'Radio':
          return ratioQuestion(context);
        case 'Slider':
          return sliderQuestion(context);
        case 'Numeros':
          return numberQuestion(context);
        case 'Text':
          return textQuestion(context);
        default:
          return const SizedBox();
      }
    });
  }

  Widget sliderQuestion(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSliderPreview(context),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  labelText: 'Valor mínimo',
                  hintText: 'Ej: 0',
                  controller: controller.textFieldController('sliderMin'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFieldWidget(
                  labelText: 'Valor máximo',
                  hintText: 'Ej: 100',
                  controller: controller.textFieldController('sliderMax'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFieldWidget(
            labelText: 'Divisiones',
            hintText: 'Número de divisiones en la escala (Ej: 10)',
            controller: controller.textFieldController('sliderDivisions'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  labelText: 'Prefijo',
                  hintText: 'Texto antes del valor (Ej: dolar)',
                  controller: controller.textFieldController('sliderPrefix'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFieldWidget(
                  labelText: 'Sufijo',
                  hintText: 'Texto después del valor (Ej: %)',
                  controller: controller.textFieldController('sliderSuffix'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSliderPreview(BuildContext context) {
    final theme = Theme.of(context);
    double min = 0;
    double max = 100;
    double value = 50;
    int divisions = 10;
    
    try {
      min = double.tryParse(controller.textFieldController('sliderMin').text) ?? 0;
      max = double.tryParse(controller.textFieldController('sliderMax').text) ?? 100;
      divisions = int.tryParse(controller.textFieldController('sliderDivisions').text) ?? 10;
      value = (min + max) / 2;
    } catch (_) {}
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vista previa',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.round().toString(),
            onChanged: (_) {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(min.toString()),
              Text(max.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget numberQuestion(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNumberPreview(context),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  labelText: 'Valor mínimo',
                  hintText: 'Ej: 0',
                  controller: controller.textFieldController('integerMin'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFieldWidget(
                  labelText: 'Valor máximo',
                  hintText: 'Ej: 100',
                  controller: controller.textFieldController('integerMax'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFieldWidget(
            labelText: 'Sufijo',
            hintText: 'Texto después del valor (Ej: años)',
            controller: controller.textFieldController('integerSuffix'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNumberPreview(BuildContext context) {
    final theme = Theme.of(context);
    String suffix = controller.textFieldController('integerSuffix').text;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vista previa',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '42',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                if (suffix.isNotEmpty)
                  Text(
                    suffix,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget textQuestion(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextPreview(context),
          const SizedBox(height: 20),
          TextFieldWidget(
            labelText: 'Texto de ayuda',
            hintText: 'Texto que aparecerá como guía para responder',
            controller: controller.textFieldController('textHint'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTextPreview(BuildContext context) {
    final theme = Theme.of(context);
    String hintText = controller.textFieldController('textHint').text;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vista previa',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: hintText.isEmpty ? 'Escribe tu respuesta aquí...' : hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}