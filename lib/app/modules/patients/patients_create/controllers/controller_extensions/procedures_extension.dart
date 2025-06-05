import 'package:domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';

extension ProceduresExtension on PatientsCreateController {

  Future<void> saveAndContinueFromProcedures() async {
    try {
      if (medicalPassport.value == null) return;

      final procedures = procedureControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) {
          final existingProcedure = medicalPassport.value!.procedures
              .firstWhere((p) => p.uniqueId != null,
                  orElse: () => Procedure(description: controller.text));

          return existingProcedure.uniqueId != null
              ? existingProcedure.copyWith(description: controller.text)
              : Procedure(description: controller.text);
        })
        .toList();

      medicalPassport.value = medicalPassport.value!.copyWith(
        procedures: procedures
      );
      
      moveToNextForm();
    } catch (e) {
      Get.snackbar(
        'Error', 
        'No se pudieron guardar los procedimientos: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    }

  void loadProcedures() {
    for (var controller in procedureControllers) {
      controller.dispose();
    }
    procedureControllers.clear();
    procedureIds.clear();

    if (medicalPassport.value?.procedures != null) {
      final procedures = medicalPassport.value!.procedures
          .map((p) => p)
          .toList();
          
      for (var procedure in procedures) {
        procedureControllers.add(
          TextEditingController(text: procedure.description)
        );
        procedureIds.add(procedure.uniqueId.toString());
      }
    }
  }

  void removeProcedureField(int index) {
    final controller = procedureControllers[index];
    controller.dispose();
    procedureControllers.removeAt(index);
    
    if (index < procedureIds.length) {
      final procedureId = procedureIds[index];
      if (procedureId.isNotEmpty) {
        medicalPassportRepository.deleteProcedure(procedureId);
        if (medicalPassport.value?.procedures != null) {
          medicalPassport.value!.procedures.removeAt(index);
        }
      }
      procedureIds.removeAt(index);
    }
  }

  void addProcedureField([String? id]) {
    procedureControllers.add(TextEditingController());
    procedureIds.add(id ?? '');
  }
}