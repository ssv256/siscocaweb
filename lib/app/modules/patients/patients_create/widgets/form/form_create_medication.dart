import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';
import 'package:siscoca/app/modules/patients/patients_create/widgets/medication_form_selector.dart';
import 'package:siscoca/app/modules/patients/patients_create/widgets/meal_timing_selector.dart';
import '../../../../../widgets/buttons/ed_button.dart';
import '../../../../../widgets/inputs/main_input.dart';

class FormCreateMedication extends GetView<PatientsCreateController> {
  const FormCreateMedication({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: controller.medicationFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMedicationList(context),
            _buildAddMedicationCard(context),
            Obx(() => controller.showMedicationForm.value 
              ? _buildMedicationFields(context)
              : const SizedBox.shrink()
            ),
            const SizedBox(height: 30),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationList(BuildContext context) {
    return Obx(() => controller.existingMedications.isEmpty
      ? Card(
          elevation: 2,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          color: Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(Icons.medication_outlined, 
                  color: Colors.grey.shade400, 
                  size: 48
                ),
                const SizedBox(height: 12),
                const Text(
                  'No hay medicaciones registradas',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Use el botón "Añadir nueva medicación" para comenzar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
      : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.existingMedications.length,
          itemBuilder: (context, index) {
            final medication = controller.existingMedications[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              color: Colors.white,
              shadowColor: Colors.black.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Medication form icon
                    if (medication.medication_form != null && medication.medication_form!.isNotEmpty)
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: _getMedicationIcon(medication.medication_form!),
                        ),
                      ),
                    const SizedBox(width: 16),
                    // Medication details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medication.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (medication.amount != null && medication.amount!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Dosis: ${medication.amount}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          if (medication.description != null && medication.description!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Instrucciones: ${medication.description}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          if (medication.takenMeal != null && medication.takenMeal!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Tomar: ${medication.takenMeal}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Action buttons
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => controller.editMedication(medication, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDeleteMedication(context, index),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
    );
  }

  Widget _getMedicationIcon(String medicationForm) {
    Color iconColor = Theme.of(Get.context!).primaryColor;
    
    switch (medicationForm) {
      case 'pill':
        return Icon(Icons.medication_outlined, color: iconColor, size: 28);
      case 'tablet':
        return Icon(Icons.medication, color: iconColor, size: 28);
      case 'sachet':
        return Icon(Icons.ad_units_outlined, color: iconColor, size: 28);
      case 'drops':
        return Icon(Icons.water_drop_outlined, color: iconColor, size: 28);
      case 'syrup':
        return Icon(Icons.local_drink_outlined, color: iconColor, size: 28);
      case 'injection':
        return Icon(Icons.vaccines_outlined, color: iconColor, size: 28);
      default:
        return Icon(Icons.medical_information, color: iconColor, size: 28);
    }
  }

  Future<void> _confirmDeleteMedication(BuildContext context, int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Eliminar medicación'),
        content: const Text(
          '¿Estás seguro que deseas eliminar esta medicación? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    
    if (result == true) {
      controller.deleteMedication(index);
    }
  }

  Widget _buildAddMedicationCard(BuildContext context) {
    return Obx(() => Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          if (controller.showMedicationForm.value) {
            controller.cancelEditing();
          } else {
            controller.showMedicationForm.value = true;
            controller.currentEditingMedicationIndex.value = -1;
            controller.clearMedicationForm();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                controller.showMedicationForm.value ? Icons.remove_circle : Icons.add_circle,
                color: Theme.of(context).primaryColor,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.showMedicationForm.value ? 'Ocultar formulario de medicación' : 'Añadir nueva medicación',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Registra los detalles de la medicación del paciente',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                controller.showMedicationForm.value ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildMedicationFields(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nombre medicación',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFieldWidget(
                  title: '',
                  hintText: 'Eplerenona',
                  controller: controller.medicationNameController,
                  validate: (value) {
                    // if (value == null || value.isEmpty) {
                    //   return 'El nombre de la medicación es requerido';
                    // }
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dosis',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFieldWidget(
                  title: '',
                  hintText: 'Eplerenona 25 mg x 4',
                  controller: controller.medicationDoseController,
                  validate: (value) {
                    // if (value == null || value.isEmpty) {
                    //   return 'La dosis es requerida';
                    // }
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Descripción',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFieldWidget(
                  title: '',
                  
                  controller: controller.medicationInstructionsController,
                  maxLines: 3,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es requerida';
                    }
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => MedicationFormSelector(
              selectedType: controller.selectedMedicationForm.value,
              onSelected: (value) => controller.selectedMedicationForm.value = value,
            )),
            const SizedBox(height: 16),
            Obx(() => MealTimingSelector(
              initialTiming: controller.selectedMealTiming.value,
              onMealTimingSelected: (value) => controller.selectedMealTiming.value = value,
            )),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => controller.cancelEditing(),
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  label: const Text('Cancelar', style: TextStyle(color: Colors.red)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(width: 16),
                Obx(() => ElevatedButton.icon(
                  onPressed: () => controller.currentEditingMedicationIndex.value >= 0 
                    ? controller.updateMedication() 
                    : controller.addMedication(),
                  icon: Icon(
                    controller.currentEditingMedicationIndex.value >= 0 
                    ? Icons.save 
                    : Icons.add_circle,
                    color: Colors.white,
                  ),
                  label: Text(
                    controller.currentEditingMedicationIndex.value >= 0 
                    ? 'Actualizar' 
                    : 'Agregar',
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('¿Estás seguro de enviar el formulario?'),
        content: const Text(
          'Al confirmar, se guardará toda la información del paciente y sus medicamentos. '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Widget _buildSubmitButton(BuildContext context) {
    return EdButton(
      width: double.infinity,
      textColor: Colors.white,
      bgColor: Theme.of(context).primaryColor,
      text: 'Finalizar',
      onTap: () async {
        if (!controller.medicationFormKey.currentState!.validate()) {
          return;
        }
        final shouldSubmit = await _showConfirmationDialog(context);
        if (!shouldSubmit) return;
        try {
          controller.save();
        } catch (e) {
          Get.snackbar(
            'Error',
            'No se pudo crear el paciente: $e',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }
}