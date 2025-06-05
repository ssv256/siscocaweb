import 'package:domain/models/models.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';

extension ClinicalInfoFormExtension on PatientsCreateController {

  Future<void> loadStudies() async {
    availableStudies.value = await studyRepository.getStudies();
    if (medicalPassport.value?.studies != null) {
      selectedStudies.value = medicalPassport.value!.studies;
    }
  }


  void updateClinicalValue(String field, String value) {
    clinicalValues[field]?.value = value;
    if (field == 'deviceCarrier') {
      showDeviceBrands.value = value != 'No';
    }
    if (field == 'anticoagulation') {
      showAnticoagulationMeds.value = value == 'Si';
    }
  }

  Future<void> saveClinicalInfo() async {
    if (medicalPassport.value == null) return;
    try {
      final existingId = medicalPassport.value?.clinicalInfo?.uniqueId;
      final updatedClinicalInfo = ClinicalInfo(
        allergies: allergiesController.text,
        anticoagulation: clinicalValues['anticoagulation']?.value == 'Si',
        anticoagulationMedication: anticoagulationMedsController.text,
        deviceBrands: deviceBrandsController.text,
        implantableDevices: clinicalValues['deviceCarrier']?.value ?? 'No',
        increaseEndocarditisRisk: clinicalValues['endocarditis']?.value == 'Si',
        pregnantRisk: clinicalValues['pregnancyRisk']?.value ?? '',
        uniqueId: existingId
      );
      
      // Ensure we keep existing studies if none are selected
      final updatedStudies = selectedStudies.isEmpty 
          ? medicalPassport.value?.studies ?? []
          : selectedStudies;
          
      medicalPassport.value = medicalPassport.value!.copyWith(
        clinicalInfo: updatedClinicalInfo,
        studies: updatedStudies,
        studyIdList: updatedStudies.isEmpty
            ? medicalPassport.value?.studyIdList ?? []
            : updatedStudies.map((study) => study.id).whereType<int>().toList()
      );
    } catch (e) {
      rethrow;
    }
  }

  void updateSelectedStudies(List<String> studyNames) {

    if (studyNames.isEmpty) {
      selectedStudies.value = medicalPassport.value?.studies ?? [];
      return;
    }
    
    selectedStudies.value = availableStudies
      .where((study) => studyNames.contains(study.studyName))
      .toList();
  }

  /// Validates clinical information
  bool validateClinicalInfo() {
    var isValid = true;
    clinicalValues.forEach((field, value) {
      if (value.value.isEmpty) {
        clinicalErrors[field]?.value = true;
        isValid = false;
      }
    });
    return isValid;
  }
}