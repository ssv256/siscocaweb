import 'package:domain/domain.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_impl_repository.dart';
import 'package:siscoca/app/data/repository/patient/measures.dart';
import 'package:siscoca/app/data/repository/patient/patient.dart';

import '../../../data/controller/brain.dart';
import '../../../data/mixin/loader_mixin.dart';

class HomeController extends GetxController with LoaderMixin  {

  final PatientRepository patientRepository;
  final MeasureRepository measureRepository;
  final AlertRepositoryImpl alertRepository;

  HomeController({
    required this.patientRepository,
    required this.measureRepository,
    required this.alertRepository,
  });

  final Brain brain = Get.find<Brain>();
  final isLoading = false.obs;
  final patients = <User>[].obs;
  final alerts = <Alert>[].obs;
  int totalAlerts = 0;
  int totalPatients = 0;
  final measuresPerDay = <Map<DateTime, int>>[].obs;
  final patientsWithUnreadAlerts = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPatients();
    _loadMeasuresPerDay();
    _loadAlerts();
  }

  Future<void> _loadPatients() async {
    isLoading.value = true;
    try {
      List<User> result;
      result = await patientRepository.getPatients();     
      patients.assignAll(result);
      totalPatients = result.length;
      
      if (patientsWithUnreadAlerts.isNotEmpty) {
        _sortPatientsByAlerts();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load patients: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadMeasuresPerDay() async {
    try {
      final List<Map<DateTime, int>> measures = await measureRepository.getTotalMeasuresWeek();
      measuresPerDay.assignAll(measures);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load measures: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _loadAlerts() async  {
    try {
      totalAlerts = await alertRepository.getTotalAlerts();
      final alertsList = await alertRepository.getAlerts();
      alerts.assignAll(alertsList);
      
      patientsWithUnreadAlerts.clear();
      for (final alert in alertsList) {
        if (!alert.isRead && alert.patientId.id != null) {
          patientsWithUnreadAlerts[alert.patientId.id!] = true;
        }
      }
      
      _sortPatientsByAlerts();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load alerts: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void _sortPatientsByAlerts() {
    if (patients.isEmpty) return;
    
    final sortedPatients = List<User>.from(patients);
    
    sortedPatients.sort((a, b) {
      final aHasAlerts = hasUnreadAlerts(a.id);
      final bHasAlerts = hasUnreadAlerts(b.id);
      
      if (aHasAlerts && !bHasAlerts) return -1;
      if (!aHasAlerts && bHasAlerts) return 1;
      return 0;
    });
    
    patients.assignAll(sortedPatients);
  }

  bool hasUnreadAlerts(String? patientId) {
    if (patientId == null) return false;
    return patientsWithUnreadAlerts[patientId] == true;
  }
}