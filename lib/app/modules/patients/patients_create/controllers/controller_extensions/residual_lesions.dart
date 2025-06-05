import 'package:domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';

extension ResidualLesionsExtension on PatientsCreateController {
  void addLesionField([String? id]) {
    lesionControllers.add(TextEditingController());
    residualLesionsIds.add(id ?? '');
  }

  void removeLesionField(int index) {
    final controller = lesionControllers[index];
    controller.dispose();
    lesionControllers.removeAt(index);
    if (index < residualLesionsIds.length) {
      final lesionId = residualLesionsIds[index];
      if (lesionId.isNotEmpty) {
        medicalPassportRepository.deleteResidualLesion(lesionId);
        if (medicalPassport.value?.residualLesions != null) {
          medicalPassport.value!.residualLesions.removeAt(index);
        }
      }
      residualLesionsIds.removeAt(index);
    }
  }

  Future<void> saveAndContinueFromLesions() async {
    try {
      if (medicalPassport.value == null) return;
      
      final updatedLesions = lesionControllers
          .where((controller) => controller.text.isNotEmpty)
          .map((controller) {
            final existingLesion = medicalPassport.value!.residualLesions
                .firstWhere((l) => l.uniqueId != null, 
                    orElse: () => ResidualLesions(description: controller.text));
                
            return existingLesion.uniqueId != null 
                ? existingLesion.copyWith(description: controller.text)
                : ResidualLesions(description: controller.text);
          })
          .toList();

      final updated = medicalPassport.value!.copyWith(
        residualLesions: updatedLesions
      );
      medicalPassport.value = updated;
      
      moveToNextForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron guardar las lesiones: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void loadResidualLesions() {
    for (var controller in lesionControllers) {
      controller.dispose();
    }
    residualLesionsIds.clear();
    lesionControllers.clear();

    if (medicalPassport.value?.residualLesions != null) {
      final lesions = medicalPassport.value!.residualLesions
          .map((l) => l)
          .toList();
          
      for (var lesion in lesions) {
        lesionControllers.add(TextEditingController(text: lesion.description));
         residualLesionsIds.add(lesion.uniqueId.toString());
      }
    }
  }
}