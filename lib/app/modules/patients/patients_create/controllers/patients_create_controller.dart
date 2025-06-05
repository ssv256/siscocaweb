import 'package:domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/data/repository/medical_passport/medical_passport_repository.dart';
import 'package:siscoca/app/data/repository/patient/patient.dart';
import 'package:siscoca/app/data/repository/study/study_repository.dart';
import 'package:siscoca/app/modules/patients/patients_create/controllers/controller_extensions/index.dart';
import 'package:siscoca/app/modules/patients/patients_create/controllers/controller_extensions/residual_lesions.dart';

class PatientsCreateController extends GetxController {
  final PatientRepository patientRepository;
  final MedicalPassportRepositoryWeb medicalPassportRepository;
  final StudyRepository studyRepository;

  PatientsCreateController(
    this.patientRepository,
    this.medicalPassportRepository,
    this.studyRepository
  );

  // Form navigation state
  final currentFormIndex = 0.obs;
  final completedForms = <int>[].obs;
  final Brain brain = Get.find<Brain>();
  bool isEdit = false;
  // Form data objects
  final patient = Rxn<User>();
  final medicalPassport = Rxn<MedicalPassport>();
  final study = Study;
  final availableStudies = <Study>[].obs;
  final selectedStudies = <Study>[].obs;
  final personalizedAlertThresholds = <AlertThreshold>[].obs;

  final patientFormKey = GlobalKey<FormState>();
  final constantsFormKey = GlobalKey<FormState>();
  final pathologyFormKey = GlobalKey<FormState>();
  final clinicalInfoFormKey = GlobalKey<FormState>();
  final proceduresFormKey = GlobalKey<FormState>();
  final residualLesionsFormKey = GlobalKey<FormState>();
  final medicationFormKey = GlobalKey<FormState>();
  
  // Reactive variables for vital signs
  final oxygenLevel = ''.obs;
  final bloodPressure = ''.obs;
  final heartRate = ''.obs;

  // Patient User
  late final TextEditingController nameController;
  late final TextEditingController lastNameController;
  late final TextEditingController patientNumberController;
  late final TextEditingController emailController;
  final selectedGender = ''.obs;
  final genderError = false.obs;
  final MaskedTextController birthDateController = MaskedTextController(mask: '00/00/0000');
  final ageRx = RxInt(0);

  final allergiesController = TextEditingController();
  final deviceBrandsController = TextEditingController();
  final anticoagulationMedsController = TextEditingController();
  final showDeviceBrands = false.obs;
  final showAnticoagulationMeds = false.obs;

  //Constant Patient
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final oxygenController = TextEditingController();
  final bloodPressureController = TextEditingController();
  final heartRateController = TextEditingController();

  final medicationNameController = TextEditingController();
  final medicationDoseController = TextEditingController();
  final medicationFrequencyController = TextEditingController();
  final medicationInstructionsController = TextEditingController();
  final selectedMedicationForm = ''.obs;
  final selectedMealTiming = ''.obs;

  /// Selected pathology values
  final selectedGeneralPathology = ''.obs;
  final selectedSpecificPathology = ''.obs;
  final isLoadingPathologies = false.obs;
  final availablePathologies = <String>[].obs;
  final availableSpecificPathologies = <String>[].obs;
  final generalPathologyError = false.obs;
  final specificPathologyError = false.obs;
  final showMedicationForm = false.obs;

  // Medication list
  final RxList<Medication> existingMedications = <Medication>[].obs;
  final RxInt currentEditingMedicationIndex = (-1).obs;

  final procedureControllers = <TextEditingController>[].obs;
  final RxList<String> procedureIds = <String>[].obs;
  final RxList<String> residualLesionsIds = <String>[].obs;
  final lesionControllers = <TextEditingController>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    initializeControllers();
    if (args is List && args.length == 2) {
      patient.value = args[0] as User;
      medicalPassport.value = args[1] as MedicalPassport;
      isEdit = true;
      loadExistingData();
      loadPersonalizedAlertThresholds();
    } else {
      medicalPassport.value = initializedMedication();
      loadExistingData();
    }
    
    testLoadConstantsData();
    loadStudies();
    loadPathologyData();
  }

  @override
  void onClose() {
    for (final controller in procedureControllers) {
      controller.dispose();
    }
    _disposeControllers();
    super.onClose();
  }

  /// Validates current form and moves to next if valid
  Future<void> validateAndContinue() async {
    if (!_isCurrentFormValid()) return;
    try {
      moveToNextForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save form data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool _isCurrentFormValid() {
    switch (currentFormIndex.value) {
      case 0: // Nuevo Paciente
        return validatePatientForm();
      case 1: // Constantes
        return validateAndSaveConstants();
      case 2: // Alertas
        return true;
      case 3: // Patología
        return validatePathologySelections();
      case 4: // Información clinica
        return validateClinicalInfo();
      case 5: // Procedimientos
        return true;
      case 6: // Lesiones Residuales
        return true; 
      case 7: // Medicación
        return true;
      default:
        return false;
    }
  }

  /// Public method to validate the current form without navigation
  bool validateCurrentForm() {
    return _isCurrentFormValid();
  }

  void moveToNextForm() {
    if (!completedForms.contains(currentFormIndex.value)) {
      completedForms.add(currentFormIndex.value);
    }
    if (currentFormIndex.value < 8) {
      currentFormIndex.value++;
    }
  }

  /// Checks if user can proceed to the next form
  bool canProceedToNext(int formIndex) {
    return patient.value != null || completedForms.contains(formIndex) || formIndex <= currentFormIndex.value;
  } 

  Future<void> save() async {
    try {
      await getDataFromControllersAndSave();
      if (isEdit) {
        await updateExistingPatient();
      } else {
        await createMedicalPassport();
      }

      Get.snackbar(
        'Éxito',
        patient.value != null ? 'Paciente actualizado correctamente' : 'Paciente creado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );

      savePersonalizedAlertThresholds(medicalPassport.value!.patientId);

      Get.offNamed('/patients');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al ${patient.value != null ? 'actualizar' : 'crear'} el paciente: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateExistingPatient() async {
    try{
      await medicalPassportRepository.updateMedicalPassport( medicalPassport.value!);
    }catch(e){
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> createMedicalPassport() async {
    try{
      await medicalPassportRepository.createMedicalPassport(medicalPassport.value!);
    }catch(e){
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> getDataFromControllersAndSave() async {
    User newUser = await savePatient();
    
    final updatedPassport = medicalPassport.value!.copyWith(
      patientId: newUser.id,
    );
    medicalPassport.value = updatedPassport;
    saveConstants();
    saveClinicalInfo();
    savePathology();
    saveAndContinueFromProcedures();
    saveAndContinueFromLesions();
    saveMedication(newUser);
  }

  // Alert threshold methods
  Future<void> addPersonalizedAlertThreshold(AlertThreshold threshold) async {
    personalizedAlertThresholds.add(threshold);
  }

  Future<void> updatePersonalizedAlertThreshold(int index, AlertThreshold threshold) async {
    if (index >= 0 && index < personalizedAlertThresholds.length) {
      personalizedAlertThresholds[index] = threshold;
    }
  }

  Future<void> removePersonalizedAlertThreshold(int index) async {
    if (index >= 0 && index < personalizedAlertThresholds.length) {
      personalizedAlertThresholds.removeAt(index);
    }
  }

  MedicalPassport initializedMedication() {
    return MedicalPassport(
      id: null,
      clinicalInfo: null,
      documentsOthers: '',
      medications: [],
      pathology: Pathology(generalPathology: '', specificPathology: ''),
      patientConstants: [],
      patientId: '',
      procedures: [],
      residualLesions: [],
      studies: [],
      studyIdList: []
    );
  }

  void loadExistingData() {
    if (patient.value != null) {
      nameController.text = patient.value?.name ?? '';
      lastNameController.text = patient.value?.surname ?? '';
      patientNumberController.text = patient.value?.patientNumber ?? '';
      emailController.text = patient.value?.email ?? '';
      selectedGender.value = patient.value?.sex ?? '';
      birthDateController.text = patient.value?.birthDate ?? '';
    }

    if (medicalPassport.value != null) {
      final constants = medicalPassport.value?.patientConstants.firstOrNull;
      weightController.text = constants?.weight.toString() ?? '';
      heightController.text = constants?.height.toString() ?? '';
      oxygenController.text = constants?.oxygenSaturation.toString() ?? '';
      bloodPressureController.text = constants?.bloodPressure ?? '';
      heartRateController.text = constants?.pulseRate.toString() ?? '';
    }

    if(medicalPassport.value?.pathology != null){
      selectedGeneralPathology.value = medicalPassport.value!.pathology.generalPathology;
      selectedSpecificPathology.value = medicalPassport.value!.pathology.specificPathology;
    }

    if (medicalPassport.value?.clinicalInfo != null) {
      final clinicalInfo = medicalPassport.value!.clinicalInfo;
      allergiesController.text = clinicalInfo?.allergies ?? '';
      deviceBrandsController.text = clinicalInfo?.implantableDevices ?? '';
      anticoagulationMedsController.text = clinicalInfo?.anticoagulationMedication ?? '';
      showDeviceBrands.value = clinicalInfo?.implantableDevices.isNotEmpty ?? false;
      showAnticoagulationMeds.value = clinicalInfo?.anticoagulation ?? false;
    }
    loadProcedures();
    loadResidualLesions();
    loadMedication();
  }

  void _disposeControllers() {
    nameController.dispose();
    lastNameController.dispose();
    patientNumberController.dispose();
    emailController.dispose();
    birthDateController.dispose();
    weightController.dispose();
    heightController.dispose();
    oxygenController.dispose();
    bloodPressureController.dispose();
    heartRateController.dispose();
    medicationNameController.dispose();
    medicationDoseController.dispose();
    medicationFrequencyController.dispose();
    medicationInstructionsController.dispose();
    for (final controller in procedureControllers) {
      controller.dispose();
    }
    for (final controller in lesionControllers) {
      controller.dispose();
    }
  }
}