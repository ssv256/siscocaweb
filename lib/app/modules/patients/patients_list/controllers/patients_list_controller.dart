import 'package:domain/domain.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/alerts/alerts_impl_repository.dart';
import 'package:siscoca/app/data/repository/patient/patient.dart';
import 'package:siscoca/app/data/repository/study/study_repository.dart' as app_study;

class PatientListController extends GetxController {
  PatientListController({
    required this.repository,
    required this.studyRepository,
    required this.alertRepository,
  });

  final PatientRepository repository;
  final app_study.StudyRepository studyRepository;
  final AlertRepositoryImpl alertRepository;
  final Brain brain = Get.find<Brain>();
  final Study? study = Get.arguments as Study?;
  final isLoading = false.obs;
  final width = 1000.0.obs;
  final patients = <User>[].obs;
  final patientsFiltered = <User>[].obs;
  
  final studies = <Study>[].obs;
  final selectedStudies = <Study>[].obs;
  final isLoadingStudies = false.obs;
  
  final alerts = <Alert>[].obs;
  final patientsWithUnreadAlerts = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPatients();
    _loadStudies();
    _loadAlerts();
  }

  Future<void> _loadPatients() async {
    isLoading.value = true;
    try {
      List<User> result;
      if (study != null) {
        result = await repository.getPatientByStudyId(study!.id!.toString()); 
      } else {
        result = await repository.getPatients();
      }
      
      patients.assignAll(result);
      patientsFiltered.assignAll(result);
      
      if (alerts.isNotEmpty) {
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

  Future<void> _loadStudies() async {
    isLoadingStudies.value = true;
    try {
      final result = await studyRepository.getStudies();
      studies.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load studies: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingStudies.value = false;
    }
  }

  Future<void> _loadAlerts() async  {
    try {
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
    final sortedPatients = List<User>.from(patients);
    
    sortedPatients.sort((a, b) {
      final aHasAlerts = hasUnreadAlerts(a.id);
      final bHasAlerts = hasUnreadAlerts(b.id);
      
      if (aHasAlerts && !bHasAlerts) return -1;
      if (!aHasAlerts && bHasAlerts) return 1;
      return 0;
    });
    
    patients.assignAll(sortedPatients);
    
    if (patientsFiltered.length == patients.length) {
      patientsFiltered.assignAll(sortedPatients);
    }
  }
  
  bool hasUnreadAlerts(String? patientId) {
    if (patientId == null) return false;
    return patientsWithUnreadAlerts[patientId] == true;
  }

  void filter(String value) {
    if (value.isEmpty) {
      patientsFiltered.assignAll(patients);
      return;
    }

    final filtered = patients.where((patient) {
      final searchValue = value.toLowerCase();
      final id = patient.id!.toLowerCase();
      final name = patient.name?.toLowerCase() ?? '';
      final surname = patient.surname?.toLowerCase() ?? '';
      final email = patient.email?.toLowerCase() ?? '';

      return id.contains(searchValue) ||
          name.contains(searchValue) ||
          surname.contains(searchValue) ||
          email.contains(searchValue);
    }).toList();

    _sortFilteredPatients(filtered);
    patientsFiltered.assignAll(filtered);
  }

  void filterStatus(String status) {
    if (status == 'All') {
      patientsFiltered.assignAll(patients);
      return;
    }

    final filtered = patients.where((patient) {
      final isActive = !patient.isNewUser;
      return status == 'Active' ? isActive : !isActive;
    }).toList();

    _sortFilteredPatients(filtered);
    patientsFiltered.assignAll(filtered);
  }

  Future<void> removePatient(String id) async {
    isLoading.value = true;
    try {
      await repository.deletePatient(id);
      await _loadPatients();
      Get.snackbar(
        'Success',
        'Patient deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete patient: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String getStatusText(bool isNewUser) {
    return isNewUser ? 'New' : 'Active';
  }

  String getDisplayName(User patient) {
    return '${patient.name ?? ''} ${patient.surname ?? ''}'.trim();
  }

  void updateSelectedStudies(Study study, bool isSelected) {
    if (isSelected && !selectedStudies.contains(study)) {
      selectedStudies.add(study);
    } else if (!isSelected && selectedStudies.contains(study)) {
      selectedStudies.remove(study);
    }
    filterByStudies();
  }

  Future<void> filterByStudies() async {
    if (selectedStudies.isEmpty) {
      patientsFiltered.assignAll(patients);
      return;
    }

    isLoading.value = true;
    try {
      final Set<User> filteredPatients = {};
      
      for (final study in selectedStudies) {
        final studyPatients = await repository.getPatientByStudyId(study.id!.toString());
        filteredPatients.addAll(studyPatients);
      }
      
      final filteredList = filteredPatients.toList();
      _sortFilteredPatients(filteredList);
      
      patientsFiltered.assignAll(filteredList);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to filter patients by studies: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      patientsFiltered.assignAll(patients);
    } finally {
      isLoading.value = false;
    }
  }
  
  void _sortFilteredPatients(List<User> patientsList) {
    patientsList.sort((a, b) {
      final aHasAlerts = hasUnreadAlerts(a.id);
      final bHasAlerts = hasUnreadAlerts(b.id);
      
      if (aHasAlerts && !bHasAlerts) return -1;
      if (!aHasAlerts && bHasAlerts) return 1;
      return 0;
    });
  }

  void resetStudyFilters() {
    selectedStudies.clear();
    patientsFiltered.assignAll(patients);
  }
}