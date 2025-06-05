import 'package:domain/models/models.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/medical_passport/medical_passport_repository.dart';
import 'package:siscoca/app/data/repository/patient/measures.dart';
import 'package:siscoca/app/data/repository/patient/patient.dart';

class PatientsDetailController extends GetxController {
  PatientsDetailController(
    this.patientRepository,
    this.medicalPassportRepository,
    this.measureRepository
  );

  final PatientRepository patientRepository;
  final MedicalPassportRepositoryWeb medicalPassportRepository;
  final MeasureRepository measureRepository;
  final Brain brain = Get.find<Brain>();

  final RxList<HealthDataPoint> healthDataPoints = <HealthDataPoint>[].obs;
  final Rx<Map<DateTime, int>> dataList = Rx<Map<DateTime, int>>({});
  final medicalPassport = Rxn<MedicalPassport>();
  final _patient = Rxn<User>();
  final selectedTabIndex = 0.obs;
  final isHeatmapExpanded = true.obs;

  // List of health data types we're interested in
  final List<HealthDataType> supportedDataTypes = [
    HealthDataType.BLOOD_PRESSURE,
    HealthDataType.HEART_RATE,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.WEIGHT,
    HealthDataType.MOOD,
  ];

  @override
  void onInit() {
    super.onInit();
    _initializePatient();
  }

  void _initializePatient() {
    try {
      // Clear any previous data first
      resetData();
      
      if (Get.arguments == null) {
        throw Exception('No se proporcionaron argumentos del paciente');
      }
      final User patient = Get.arguments as User;
      _patient.value = patient;

      if (patient.id != null) {
        _loadMedicalPassport(patient);
        _loadMeasures(patient);
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cargar la información del paciente');
      Get.back();
    }
  }

  // Format date for display
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Get count of readings for a specific data type
  int getReadingCount(HealthDataType type) {
    return healthDataPoints.where((point) => point.type == type).length;
  }

  Future<void> _loadMedicalPassport(User patient) async {
    try {
      medicalPassport.value = await medicalPassportRepository.getMedicalPassport(patient.id!);
      update(); // Notificar a los widgets que estén usando GetBuilder
    } catch (e) {
      medicalPassport.value = null;
      update();
    }
  }

  Future<void> _loadMeasures(User patient) async {
    try{
      healthDataPoints.value = await measureRepository.getHealthDataPoints(patient.id!);
      _loadDailyCounts();
      update();
    } catch (e) {
      print('Error con measures: $e');
      medicalPassport.value = null;
      update();
    }
  }

  Future<void> reloadData() async {
    if (_patient.value?.id != null) {
      await _loadMedicalPassport(_patient.value!);
      await _loadMeasures(_patient.value!);
    }
  }

  Future<void> _loadDailyCounts() async {
    try {
      final dailyCounts = await measureRepository.getTotalHealthDataPoints(_patient.value!.id!);
      dataList.value = dailyCounts;
      update();
    }  catch (e) {
      print('Error al obtener los dailyCounts: $e');
    }
  }
  
  // Method to reset all data when navigating between patients
  void resetData() {
    healthDataPoints.clear();
    dataList.value = {};
    medicalPassport.value = null;
    // Reset other state as needed
    update();
  }

  // Method to set the selected tab index
  void setSelectedTabIndex(int index) {
    if (index >= 0 && index < 4) { // Assuming we have 4 tabs
      selectedTabIndex.value = index;
    }
  }
}