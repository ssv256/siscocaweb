import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:domain/models/models.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_impl_repository.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_threshold_impl_rep.dart';
import 'package:siscoca/app/data/controller/brain.dart';

class AlertsController extends GetxController {
  final AlertRepositoryImpl alertRepository;
  final AlertThresholdRepositoryImpl thresholdRepository;
  
  AlertsController({
    required this.alertRepository,
    required this.thresholdRepository,
  });
  
  final RxList<Alert> alerts = <Alert>[].obs;
  final RxList<AlertThreshold> thresholds = <AlertThreshold>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isThresholdsLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxBool hasThresholdsError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString thresholdsErrorMessage = ''.obs;
  late User patient;

  void setPatient(User user) {
    patient = user;
    loadAlerts();
    loadThresholds();
  }

  Future<void> loadAlerts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      final patientAlerts = await alertRepository.getPatientAlerts(patient.id!);
      alerts.assignAll(patientAlerts);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error al cargar las alertas: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadThresholds() async {
    try {
      isThresholdsLoading.value = true;
      hasThresholdsError.value = false;
      
      final patientThresholds = await thresholdRepository.getThresholdsByPatient(patient.id!);
      thresholds.assignAll(patientThresholds);
    } catch (e) {
      hasThresholdsError.value = true;
      thresholdsErrorMessage.value = 'Error al cargar los umbrales de alerta: $e';
    } finally {
      isThresholdsLoading.value = false;
    }
  }

  Future<void> markAlertAsRead(Alert alert) async {
    try {
      final doctor = Brain.to.currentDoctor.value;
      final alertId = alert.id.toString();
      
      await alertRepository.markAsRead(alertId, doctor!.id!);
      
      final index = alerts.indexWhere((a) => a.id == alert.id);
      if (index != -1) {
        final updatedAlert = Alert(
          id: alert.id,
          patientId: alert.patientId,
          healthDataPoint: alert.healthDataPoint,
          alertThreshold: alert.alertThreshold,
          createdAt: alert.createdAt,
          isRead: true,
          readAt: DateTime.now(),
          readByDoctorId: doctor.id.toString(),
        );
        alerts[index] = updatedAlert;
      }
      
      // Show success message
      Get.snackbar(
        'Éxito',
        'Alerta marcada como leída correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo marcar la alerta como leída en este momento. Intente nuevamente más tarde.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 3),
      );
    }
  }
} 