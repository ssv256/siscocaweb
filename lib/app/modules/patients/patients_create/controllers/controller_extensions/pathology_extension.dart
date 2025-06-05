import 'package:domain/models/passport/pathology.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';

extension PathologyFormExtension on PatientsCreateController {

  void loadPathologyData() {
    try {
      isLoadingPathologies.value = true;
      availablePathologies.value = pathologyList
          .map((item) => item['value'] as String)
          .toList();
          
      if (selectedGeneralPathology.value.isNotEmpty) {
        final selectedPathology = pathologyList.firstWhere(
          (item) => item['value'] == selectedGeneralPathology.value,
          orElse: () => {'options': <String>[]}
        );
        availableSpecificPathologies.value = 
            (selectedPathology['options'] as List<dynamic>).cast<String>();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron cargar las patologías: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingPathologies.value = false;
    }
  }

  /// Handles selection of general pathology
  void onGeneralPathologySelected(String? value) {
    if (value == null) return;
    selectedGeneralPathology.value = value;

    final selectedPathology = pathologyList.firstWhere(
      (item) => item['value'] == value,
      orElse: () => {'options': <String>[]}
    );
    availableSpecificPathologies.value = (selectedPathology['options'] as List<dynamic>).cast<String>();
    selectedSpecificPathology.value = '';
  }

  /// Handles selection of specific pathology
  void onSpecificPathologySelected(String? value) {
    if (value == null) return;
    selectedSpecificPathology.value = value;
  }

  bool validatePathologySelections() {
    var isValid = true;
    generalPathologyError.value = selectedGeneralPathology.value.isEmpty;
    specificPathologyError.value = selectedSpecificPathology.value.isEmpty;

    if (selectedGeneralPathology.value.isEmpty) {
      isValid = false;
    }
    if (selectedSpecificPathology.value.isEmpty) {
      isValid = false;
    }
    // if (!generalPathologyError.value.is && !specificPathologyError.value) {
    //   isValid = false;
    // }
    return isValid;
  }

  Future<void> savePathology() async {
    try {
      if (medicalPassport.value == null) return;
      
      final existingId = medicalPassport.value?.pathology.uniqueId;
      final pathology = Pathology(
        generalPathology: selectedGeneralPathology.value,
        specificPathology: selectedSpecificPathology.value,
        uniqueId: existingId != null ? existingId : null
      );
      
      medicalPassport.value = medicalPassport.value!.copyWith(pathology: pathology);
    } catch (e) {
      print('Error saving pathology: $e');
    }
  }
}