import 'package:domain/domain.dart';
import 'package:get/get.dart';
import 'package:siscoca/app/modules/patients/patients_create/index.dart';
import 'package:uuid/uuid.dart';

extension MedicationFormExtension on PatientsCreateController {

  Future<void> saveMedication(User user) async {
    if (medicalPassport.value != null) {
      for (var medication in existingMedications) {
        if (medication.patient_id.isEmpty) {
          medication = medication.copyWith(patient_id: user.id!);
        }
      }
    }
  }

  void clearMedicationForm() {
    medicationNameController.clear();
    medicationDoseController.clear();
    medicationInstructionsController.clear();
    selectedMedicationForm.value = '';
    selectedMealTiming.value = '';
  }

  void loadMedication() {
    clearMedicationForm();
    existingMedications.clear();
    if (medicalPassport.value != null && 
        medicalPassport.value!.medications.isNotEmpty) {
      existingMedications.addAll(medicalPassport.value!.medications);
    }
  }
  
  void addMedication() {
    if (medicationNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Debes ingresar al menos el nombre de la medicación',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    final Medication newMedication = Medication(
      id: const Uuid().v4(),
      name: medicationNameController.text,
      description: medicationInstructionsController.text,
      amount: medicationDoseController.text,
      takenMeal: selectedMealTiming.value,
      medication_form: selectedMedicationForm.value,
      patient_id: patient.value?.id ?? '',
      activated: true,
      notifications: [],
      created_by_type: 'doctor',
    );
    
    existingMedications.add(newMedication);
    
    if (medicalPassport.value != null) {
      final updatedMedicalPassport = medicalPassport.value!;
      final List<Medication> updatedMedications = List.from(updatedMedicalPassport.medications)..add(newMedication);
      medicalPassport.value = updatedMedicalPassport.copyWith(
        medications: updatedMedications
      );
    }
    
    clearMedicationForm();
    showMedicationForm.value = false;
    
    Get.snackbar(
      'Éxito',
      'Medicación añadida correctamente',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void editMedication(Medication medication, int index) {
  
    medicationNameController.text = medication.name;
    medicationDoseController.text = medication.amount ?? '';
    medicationInstructionsController.text = medication.description ?? '';
    selectedMedicationForm.value = medication.medication_form ?? '';
    selectedMealTiming.value = medication.takenMeal ?? '';
    currentEditingMedicationIndex.value = index;
    showMedicationForm.value = true;
  }
  
  void updateMedication() {
    if (currentEditingMedicationIndex.value == -1) {
      addMedication();
      return;
    }
    
    if (medicationNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Debes ingresar al menos el nombre de la medicación',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    final medication = existingMedications[currentEditingMedicationIndex.value];
    
    final updatedMedication = Medication(
      id: medication.id,
      name: medicationNameController.text,
      description: medicationInstructionsController.text,
      amount: medicationDoseController.text,
      takenMeal: selectedMealTiming.value,
      medication_form: selectedMedicationForm.value,
      patient_id: medication.patient_id,
      activated: medication.activated,
      notifications: medication.notifications,
      created_by_type: medication.created_by_type,
    );
    
    existingMedications[currentEditingMedicationIndex.value] = updatedMedication;

    if (medicalPassport.value != null) {
      final updatedMedicalPassport = medicalPassport.value!;
      final List<Medication> updatedMedications = List.from(existingMedications);
      medicalPassport.value = updatedMedicalPassport.copyWith(
        medications: updatedMedications
      );
    }
    
    currentEditingMedicationIndex.value = -1;

    clearMedicationForm();
    showMedicationForm.value = false;
    
    Get.snackbar(
      'Éxito',
      'Medicación actualizada correctamente',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void deleteMedication(int index) { // Remove medication from list
    existingMedications.removeAt(index);
    if (medicalPassport.value != null) {
      final updatedMedicalPassport = medicalPassport.value!;
      final List<Medication> updatedMedications = List.from(existingMedications);
      medicalPassport.value = updatedMedicalPassport.copyWith(
        medications: updatedMedications
      );
    }

    if (currentEditingMedicationIndex.value == index) {
      currentEditingMedicationIndex.value = -1;
      clearMedicationForm();
      showMedicationForm.value = false;
    } else if (currentEditingMedicationIndex.value > index) {
      currentEditingMedicationIndex.value--;
    }
    
    Get.snackbar(
      'Éxito',
      'Medicación eliminada correctamente',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void cancelEditing() {
    // Reset editing state
    currentEditingMedicationIndex.value = -1;
    clearMedicationForm();
    showMedicationForm.value = false;
  }
}