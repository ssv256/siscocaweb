import 'package:domain/models/alerts/alerts_threshold.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_threshold_impl_rep.dart';
import 'package:siscoca/app/modules/patients/patients_create/controllers/patients_create_controller.dart';

extension AlertThresholdExtension on PatientsCreateController {

  // Load personalized alert thresholds for a patient
  Future<void> loadPersonalizedAlertThresholds() async {
    personalizedAlertThresholds.clear();
    try {
      debugPrint('Loading alert thresholds for patient ID: ${patient.value!.id}');
      final alertThresholdRepository = Get.find<AlertThresholdRepositoryImpl>();
      final thresholds = await alertThresholdRepository.getThresholdsByPatient(patient.value!.id.toString());
      
      if (thresholds.isNotEmpty) {
        debugPrint('Loaded ${thresholds.length} personalized thresholds');
        personalizedAlertThresholds.assignAll(thresholds);
      } else {
        debugPrint('No personalized thresholds found for this patient');
      }
    } catch (e) {
      debugPrint('Error loading personalized alert thresholds: $e');
    }
  }

  Future<void> removePersonalizedAlertThreshold(int index) async {
    try {
      final threshold = personalizedAlertThresholds[index];
      if (patient.value?.id != null && threshold.id > 0) {
        final alertThresholdRepository = Get.find<AlertThresholdRepositoryImpl>();
        await alertThresholdRepository.deleteAlertThreshold(threshold.id);
      }
      personalizedAlertThresholds.removeAt(index);
    } catch (e) {
      debugPrint('Error removing personalized alert threshold: $e');
    }
  }

  Future<void> savePersonalizedAlertThresholds(String patientId) async {
    try {
      debugPrint('Saving ${personalizedAlertThresholds.length} alert thresholds for patient ID: $patientId');
      final alertThresholdRepository = Get.find<AlertThresholdRepositoryImpl>();
      // Update each threshold with the patient ID
      for (final threshold in personalizedAlertThresholds) {
        final updatedThreshold = AlertThreshold(
          id: threshold.id,
          patientId: patientId,
          measureType: threshold.measureType,
          severity: threshold.severity,
          conditions: threshold.conditions,
        );
        
        debugPrint('Processing threshold: ID=${threshold.id}, type=${threshold.measureType}');
        
        if (threshold.id == 0) {
          debugPrint('Creating new threshold');
          await alertThresholdRepository.createAlertThreshold(updatedThreshold);
        } else {
          // Otherwise, update the existing threshold
          debugPrint('Updating existing threshold ID: ${threshold.id}');
          await alertThresholdRepository.updateAlertThreshold(
            threshold.id,
            updatedThreshold
          );
        }
      }
      
      debugPrint('Successfully saved all alert thresholds');
    } catch (e) {
      debugPrint('Error saving personalized alert thresholds: $e');
    }
  }
  
  // Add this method to validate and continue from alert thresholds
  Future<void> saveAndContinueFromAlertThresholds() async {
    try {
      // No validation needed for alert thresholds
      final patientId = patient.value?.id;
      if (patientId != null) {
        await savePersonalizedAlertThresholds(patientId);
      }
      // Add current form to completed forms and move to next step
      if (!completedForms.contains(currentFormIndex.value)) {
        completedForms.add(currentFormIndex.value);
      }
      moveToNextForm();
    } catch (e) {
      debugPrint('Error saving alert thresholds: $e');
      Get.snackbar(
        'Error',
        'Error al guardar las alertas personalizadas: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
} 